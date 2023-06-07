import 'package:ferry/ferry.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/support_fragment.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_support.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_support.var.gql.dart';

class UpsertSupportCacheHandler {
  const UpsertSupportCacheHandler._();

  static const String key = '@upsertSupportCacheHandler';

  static UpdateCacheHandler<GUpsertSupportData, GUpsertSupportVars> handler =
      (proxy, response) {
    final upsertData = response.operationRequest
        .updateCacheHandlerContext?['upsertData'] as GUpsertSupportInputDto;
    if (upsertData.id != null) {
      final req = GSupportReq((b) => b..idFields = {'id': upsertData.id});
      final oldSupport = proxy.readFragment(req);

      final updatedSupport = oldSupport?.rebuild(
        (b) => b..isRead = true,
      );

      proxy.writeFragment(req, updatedSupport);
    }
  };
}
