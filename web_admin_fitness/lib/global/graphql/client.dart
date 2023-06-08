import 'package:ferry/ferry.dart';
import 'package:ferry_hive_store/ferry_hive_store.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_category_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_program_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_support_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_user_cache_handler.dart';

import '../../locator.dart';
import '../services/hive_service.dart';
import '../utils/constants.dart';
import 'auth/__generated__/query_refresh_token.req.gql.dart';
import 'cache_handler/upsert_exercise_cache_handler.dart';
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
        final hiveService = locator.get<HiveService>();
        final userCredentials = hiveService.getUserCredentials();
        String? refreshToken = userCredentials.refreshToken;

        final result = await client
            .request(
              GRefreshTokenReq(
                (b) => b..vars.refreshToken = refreshToken,
              ),
            )
            .first;

        if (!result.hasErrors) {
          final newToken = result.data?.refreshToken.token;
          await hiveService.saveUserCredentials(
            userCredentials.copyWith(accessToken: newToken),
          );
        }
      },
    );

    client = Client(
      link: link,
      cache: cache,
      defaultFetchPolicies: {
        OperationType.query: FetchPolicy.CacheAndNetwork,
        OperationType.mutation: FetchPolicy.NoCache,
      },
      updateCacheHandlers: {
        UpsertCategoryCacheHandler.key: UpsertCategoryCacheHandler.handler,
        UpsertProgramCacheHandler.key: UpsertProgramCacheHandler.handler,
        UpsertExerciseCacheHandler.key: UpsertExerciseCacheHandler.handler,
        UpsertUserCacheHandler.key: UpsertUserCacheHandler.handler,
        UpsertSupportCacheHandler.key: UpsertSupportCacheHandler.handler,

        // DeleteMessageHandler.key: DeleteMessageHandler.handler,
        // MarkReadEventHandler.key: MarkReadEventHandler.handler,
      },
    );
    return client;
  }
}
