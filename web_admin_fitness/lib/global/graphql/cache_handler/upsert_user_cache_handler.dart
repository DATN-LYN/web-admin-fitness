import 'package:ferry/ferry.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_user.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_user.var.gql.dart';

class UpsertUserCacheHandler {
  const UpsertUserCacheHandler._();

  static const String key = '@upsertUserCacheHandler';

  static UpdateCacheHandler<GUpsertUserData, GUpsertUserVars> handler =
      (proxy, response) {
    final id =
        response.operationRequest.updateCacheHandlerContext?['id'] as String?;

    if (id != null) {
      final req = GUserReq((b) => b..idFields = {'id': id});
      final oldUser = proxy.readFragment(req);

      final newData = response.data != null
          ? GUserData.fromJson(response.data!.upsertUser.toJson())
          : null;

      if (newData != null && oldUser != null) {
        final updatedUser = newData;

        proxy.writeFragment(req, updatedUser);
      }
    }
  };
}
