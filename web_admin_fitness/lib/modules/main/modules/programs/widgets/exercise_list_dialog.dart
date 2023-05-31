import 'package:auto_route/auto_route.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_exercise_item.dart';
import 'package:web_admin_fitness/modules/main/modules/exercises/widgets/exercise_item.dart';

import '../../../../../global/utils/constants.dart';
import '../../../../../global/widgets/fitness_empty.dart';
import '../../../../../global/widgets/fitness_error.dart';
import '../../../../../global/widgets/infinity_list.dart';

class ExerciseListDialog extends StatefulWidget {
  const ExerciseListDialog({
    super.key,
    required this.programId,
  });

  final String programId;

  @override
  State<ExerciseListDialog> createState() => _ExerciseListDialogState();
}

class _ExerciseListDialogState extends State<ExerciseListDialog>
    with ClientMixin {
  late var getExercisesReq = GGetExercisesReq(
    (b) => b
      ..requestId = '@getExercisesRequestId'
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.page = 1
      ..vars.queryParams.orderBy = 'Exercise.name'
      ..vars.queryParams.filters = ListBuilder(
        [
          GFilterDto(
            (b) => b
              ..data = widget.programId
              ..field = 'Exercise.programId'
              ..operator = GFILTER_OPERATOR.eq,
          )
        ],
      ),
  );

  void onSearch(String? value) {
    getExercisesReq = getExercisesReq.rebuild(
      (p0) => p0
        ..vars.queryParams.page = 1
        ..updateResult = ((previous, result) => result)
        ..vars.queryParams.filters = ListBuilder(
          [
            GFilterDto(
              (b) => b
                ..data = widget.programId
                ..field = 'Exercise.programId'
                ..operator = GFILTER_OPERATOR.eq,
            ),
            GFilterDto(
              (b) => b
                ..field = 'Exercise.name'
                ..data = value
                ..operator = GFILTER_OPERATOR.like,
            ),
          ],
        ),
    );
    client.requestController.add(getExercisesReq);
  }

  void goToExerciseUpsertPage() {
    context.pushRoute(
      MainRoute(
        children: [
          ExercisesRoute(
            children: [
              const ExercisesManagerRoute(),
              ExerciseUpsertRoute(
                initialProgramId: widget.programId,
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: InfinityList(
                client: client,
                request: getExercisesReq,
                loadMoreRequest: (response) {
                  final data = response?.data?.getExercises;
                  if (data != null &&
                      data.meta!.currentPage!.toDouble() <
                          data.meta!.totalPages!.toDouble()) {
                    getExercisesReq = getExercisesReq.rebuild(
                      (b) => b
                        ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
                        ..updateResult = (previous, result) =>
                            previous?.rebuild(
                              (b) => b.getExercises
                                ..meta = (result?.getExercises.meta ??
                                        previous.getExercises.meta)!
                                    .toBuilder()
                                ..items
                                    .addAll(result?.getExercises.items ?? []),
                            ) ??
                            result,
                    );
                    return getExercisesReq;
                  }
                  return null;
                },
                refreshRequest: () {
                  getExercisesReq = getExercisesReq.rebuild(
                    (b) => b
                      ..vars.queryParams.page = 1
                      ..updateResult = ((previous, result) => result),
                  );
                  return getExercisesReq;
                },
                builder: (context, response, error) {
                  if (response?.hasErrors == true) {
                    return FitnessError(response: response);
                  }
                  if (response?.loading ?? false) {
                    return ListView.separated(
                      itemCount: 3,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemBuilder: (context, index) {
                        return const ShimmerExerciseItem();
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                    );
                  }

                  final data = response!.data!.getExercises;
                  final hasMoreData = data.meta!.currentPage!.toDouble() <
                      data.meta!.totalPages!.toDouble();
                  final exercises = data.items;

                  if (exercises?.isEmpty == true) {
                    return FitnessEmpty(
                      title: i18n.upsertProgram_ExerciseEmpty,
                    );
                  }

                  return Column(
                    children: [
                      TextFormField(
                        onChanged: (value) => onSearch(value),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: exercises!.length + (hasMoreData ? 1 : 0),
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          itemBuilder: (context, index) {
                            final item = exercises[index];
                            return ExerciseItem(
                              exercise: item,
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: goToExerciseUpsertPage,
              child: Text(i18n.upsertProgram_AddNewExercise),
            ),
          ],
        ),
      ),
    );
  }
}
