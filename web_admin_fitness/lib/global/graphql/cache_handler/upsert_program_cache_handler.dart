import 'package:ferry/ferry.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_program.var.gql.dart';

import '../mutation/__generated__/mutation_upsert_program.data.gql.dart';

class UpsertProgramCacheHandler {
  const UpsertProgramCacheHandler._();

  static const String key = '@upsertProgramCacheHandler';

  static UpdateCacheHandler<GUpsertProgramData, GUpsertProgramVars> handler =
      (proxy, response) {
    final upsertData = response.operationRequest
        .updateCacheHandlerContext?['upsertData'] as GUpsertProgramInputDto;

    if (upsertData.id != null) {
      final req = GProgramReq((b) => b..idFields = {'id': upsertData.id});
      final oldProgram = proxy.readFragment(req);

      final newData = response.data != null
          ? GProgramData.fromJson(response.data!.upsertProgram.toJson())
          : null;
      if (newData != null && oldProgram != null) {
        final updatedProgram = newData;

        proxy.writeFragment(req, updatedProgram);
      }
    }
  };
}
