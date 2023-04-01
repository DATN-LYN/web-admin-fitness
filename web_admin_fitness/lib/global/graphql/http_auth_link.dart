import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ferry/ferry.dart';
import 'package:gql_error_link/gql_error_link.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_link/gql_link.dart';
import 'package:gql_transform_link/gql_transform_link.dart';

import '../../locator.dart';
import '../enums/app_locale.dart';
import '../providers/auth_provider.dart';
import '../services/hive_service.dart';

class HttpAuthLink extends Link {
  HttpAuthLink({
    required this.getToken,
    required this.getNewToken,
    required this.graphQLEndpoint,
  }) {
    _link = Link.from([
      ErrorLink(
        onGraphQLError: handleGraphQLError,
        onException: handleException,
      ),
      TransformLink(requestTransformer: transformRequest),
    ]);
  }

  final String graphQLEndpoint;
  final String Function() getToken;
  final Future<void> Function() getNewToken;

  late Link _link;
  late String _token;
  static Future<void>? refreshTokenRequest;

  void updateToken() => _token = getToken();

  Stream<Response>? handleGraphQLError(
    Request request,
    NextLink forward,
    Response response,
  ) async* {
    log('!!! GraphQL Exception: ${response.errors?.first.message}');
    try {
      final statusCode = response.response['errors'].first['statusCode'];
      final messageCode = response.response['errors'].first['messageCode'];

      if (statusCode == 401) {
        refreshTokenRequest = refreshTokenRequest ?? getNewToken();
        await refreshTokenRequest;
        refreshTokenRequest = null;

        yield* this.request(request, forward);
        return;
      }

      if (statusCode == 400 &&
          (messageCode == 'INVALID_REFRESH_TOKEN' ||
              messageCode == 'REFRESH_TOKEN_EXPIRE')) {
        await locator.get<AuthProvider>().logout();
        //locator.get<EventBus>().fire(const LoadHomeListLocationBusEvent());
      }
    } catch (_) {}

    yield* forward(request);
  }

  Stream<Response> handleException(
    Request request,
    NextLink forward,
    LinkException exception,
  ) async* {
    log('!!! Link Exception: ${exception.originalException.toString()}');

    final message = exception is HttpLinkServerException
        ? exception.response.reasonPhrase
        : exception.toString();

    Zone.current.handleUncaughtError(
      message ?? 'Unknown error',
      StackTrace.fromString(''),
    );

    throw exception;
  }

  Request transformRequest(Request request) {
    return request.updateContextEntry<HttpLinkHeaders>(
      (headers) => HttpLinkHeaders(
        headers: <String, String>{
          ...headers?.headers ?? <String, String>{},
          'authorization': _token,
        },
      ),
    );
  }

  @override
  Stream<Response> request(
    Request request, [
    Stream<Response> Function(Request)? forward,
  ]) async* {
    updateToken();
    yield* _link
        .concat(
          HttpLink(
            graphQLEndpoint,
            defaultHeaders: {
              'Accept-Language':
                  locator.get<HiveService>().getAppSettings().locale ==
                          AppLocale.viVN
                      ? 'vi'
                      : 'en',
              'appdevice': Platform.operatingSystem.toUpperCase(),
              'appversion': '1.0.0',
            },
          ),
        )
        .request(request, forward);
  }
}
