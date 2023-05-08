import 'package:ferry/ferry.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_exercise.data.gql.dart';

import '../fragment/__generated__/exercise_fragment.data.gql.dart';
import '../fragment/__generated__/exercise_fragment.req.gql.dart';
import '../mutation/__generated__/mutation_upsert_exercise.var.gql.dart';

class UpsertExerciseCacheHandler {
  const UpsertExerciseCacheHandler._();

  static const String key = '@upsertExerciseCacheHandler';

  static UpdateCacheHandler<GUpsertExerciseData, GUpsertExerciseVars> handler =
      (proxy, response) {
    final upsertData = response.operationRequest
        .updateCacheHandlerContext?['upsertData'] as GUpsertExerciseInputDto;

    if (upsertData.id != null) {
      final req = GExerciseReq((b) => b..idFields = {'id': upsertData.id});
      final oldExercise = proxy.readFragment(req);

      final newData = response.data != null
          ? GExerciseData.fromJson(response.data!.upsertExercise.toJson())
          : null;
      if (newData != null && oldExercise != null) {
        final updatedExercise = newData;

        proxy.writeFragment(req, updatedExercise);
      }
    }
  };
}
