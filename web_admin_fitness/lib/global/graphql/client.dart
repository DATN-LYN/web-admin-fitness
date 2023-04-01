
import 'package:ferry/ferry.dart';
import 'package:ferry_hive_store/ferry_hive_store.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../locator.dart';
import '../services/hive_service.dart';
import '../utils/constants.dart';
import 'http_auth_link.dart';

class AppClient {
  final box = Hive.box(Constants.hiveGraphqlBox);
  late HiveStore store;
  late Cache cache;

  AppClient() {
    // clear cache
    box.clear();

    store = HiveStore(box);

    cache = Cache(store: store);
  }

  Future<Client> initClient() async {
    late Client client;
    final link = HttpAuthLink(
      graphQLEndpoint: Constants.graphQLEndpoint,
      getToken: () {
        final hiveService = locator.get<HiveService>();
        String? token = hiveService.getUserCredentials().accessToken;

        return 'Bearer $token';
      },
      getNewToken: () async {
        // final hiveService = locator.get<HiveService>();
        // final userCredentials = hiveService.getUserCredentials();
        // String? refreshToken = userCredentials.refreshToken;

        // final result = await client
        //     .request(
        //       GRefreshTokenReq(
        //         (b) => b..vars.input.refreshToken = refreshToken,
        //       ),
        //     )
        //     .first;

        // if (!result.hasErrors) {
        //   final newToken = result.data?.refreshToken.token;
        //   await hiveService.saveUserCredentials(
        //     userCredentials.copyWith(accessToken: newToken),
        //   );
        // }
      },
    );

    client = Client(
      link: link,
      cache: cache,
      updateCacheHandlers: {
        // ToggleFavoriteServiceHandler.key: ToggleFavoriteServiceHandler.handler,
        // ToggleFavoriteLocationHandler.key:
        //     ToggleFavoriteLocationHandler.handler,
        // MarkReadNotificationHandler.key: MarkReadNotificationHandler.handler,
        // MarkReadMessageHandler.key: MarkReadMessageHandler.handler,
        // DeleteMessageHandler.key: DeleteMessageHandler.handler,
        // MarkReadEventHandler.key: MarkReadEventHandler.handler,
      },
    );
    return client;
  }
}
