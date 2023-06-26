import 'dart:async';

import 'package:ferry/ferry.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_link/gql_link.dart';
import 'package:gql_transform_link/gql_transform_link.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_link/sentry_link.dart';

class HttpAuthLink extends Link {
  HttpAuthLink({
    required this.getToken,
    required this.getNewToken,
    required this.graphQLEndpoint,
  }) {
    _link = Link.from([
      // ErrorLink(
      //   onGraphQLError: handleGraphQLError,
      //   onException: handleException,
      // ),
      TransformLink(requestTransformer: transformRequest),
      SentryLink.link(),
      SentryTracingLink(shouldStartTransaction: true),
    ]);
  }

  final String graphQLEndpoint;
  final String Function() getToken;
  final Future<void> Function() getNewToken;

  late Link _link;
  late String _token;
  static Future<void>? refreshTokenRequest;

  void updateToken() => _token = getToken();

  // Stream<Response>? handleGraphQLError(
  //   Request request,
  //   NextLink forward,
  //   Response response,
  // ) async* {
  //   log('!!! GraphQL Exception: ${response.errors?.first.message}');
  //   try {
  //     final statusCode = response.response['errors'].first['statusCode'];
  //     final messageCode = response.response['errors'].first['messageCode'];

  //     if (statusCode == 401) {
  //       refreshTokenRequest = refreshTokenRequest ?? getNewToken();
  //       await refreshTokenRequest;
  //       refreshTokenRequest = null;

  //       yield* this.request(request, forward);
  //       return;
  //     }

  //     if (statusCode == 400 &&
  //         (messageCode == 'INVALID_REFRESH_TOKEN' ||
  //             messageCode == 'REFRESH_TOKEN_EXPIRE')) {
  //       await locator.get<AuthProvider>().logout();
  //       //locator.get<EventBus>().fire(const LoadHomeListLocationBusEvent());
  //     }
  //   } catch (_) {}

  //   yield* forward(request);
  // }

  // Stream<Response> handleException(
  //   Request request,
  //   NextLink forward,
  //   LinkException exception,
  // ) async* {
  //   log('!!! Link Exception: ${exception.originalException.toString()}');

  //   final message = exception is HttpLinkServerException
  //       ? exception.response.reasonPhrase
  //       : exception.toString();

  //   Zone.current.handleUncaughtError(
  //     message ?? 'Unknown error',
  //     StackTrace.fromString(''),
  //   );

  //   throw exception;
  // }

  Request transformRequest(Request request) {
    return request.updateContextEntry<HttpLinkHeaders>(
      (headers) => HttpLinkHeaders(
        headers: <String, String>{
          ...headers?.headers ?? <String, String>{},
          'authorization': _token,
          'Accept-Language': 'en',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE',
          'Access-Control-Allow-Headers':
              'Origin, X-Requested-With, Content-Type, Accept',
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
            httpClient: SentryHttpClient(networkTracing: true),
            serializer: SentryRequestSerializer(),
            parser: SentryResponseParser(),
          ),
        )
        .request(request, forward);
  }
}
