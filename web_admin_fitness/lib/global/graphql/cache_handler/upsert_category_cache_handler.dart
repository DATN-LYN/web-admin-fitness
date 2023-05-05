import 'package:ferry/ferry.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_category.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_category.var.gql.dart';

class UpsertCategoryCacheHandler {
  const UpsertCategoryCacheHandler._();

  static const String key = '@upsertCategoryCacheHandler';

  static UpdateCacheHandler<GUpsertCategoryData, GUpsertCategoryVars> handler =
      (proxy, response) {
    final upsertData = response.operationRequest
        .updateCacheHandlerContext?['upsertData'] as GUpsertCategoryInputDto;

    if (upsertData.id != null) {
      final req = GCategoryReq((b) => b..idFields = {'id': upsertData.id});
      final oldRemote = proxy.readFragment(req);

      final newData = response.data != null
          ? GCategoryData.fromJson(response.data!.upsertCategory.toJson())
          : null;
      if (newData != null && oldRemote != null) {
        final updatedRemote = newData;

        proxy.writeFragment(req, updatedRemote);
      }
    }
  };
}
