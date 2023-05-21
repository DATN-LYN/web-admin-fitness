import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';

import '../../../../../../../global/routers/app_router.dart';
import '../helper/exercise_helper.dart';
import 'exercise_item.dart';

class ExercisesListView extends StatefulWidget {
  const ExercisesListView({
    super.key,
    required this.request,
    required this.onRequestChanged,
  });

  final GGetExercisesReq request;
  final Function(GGetExercisesReq) onRequestChanged;

  @override
  State<ExercisesListView> createState() => _ExercisesListViewState();
}

class _ExercisesListViewState extends State<ExercisesListView>
    with ClientMixin {
  bool loading = false;
  void refreshHandler() {
    widget.onRequestChanged(
      widget.request.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  void handleDelete(GExercise exercise) async {
    setState(() => loading = true);
    await ExerciseHelper().handleDelete(context, exercise);
    refreshHandler();
    setState(() => loading = false);
  }

  void goToUpsertPage(GExercise exercise) {
    context.pushRoute(ExerciseUpsertRoute(exercise: exercise)).then(
      (value) {
        if (value != null) {
          refreshHandler();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var getCategoriesReq = widget.request;
    final i18n = I18n.of(context)!;

    return LoadingOverlay(
      isDark: false,
      loading: loading,
      child: InfinityList(
        client: client,
        request: widget.request,
        loadMoreRequest: (response) {
          final data = response?.data?.getExercises;
          if (data != null &&
              data.meta!.currentPage!.toDouble() <
                  data.meta!.totalPages!.toDouble()) {
            getCategoriesReq = widget.request.rebuild(
              (b) => b
                ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
                ..updateResult = (previous, result) =>
                    previous?.rebuild(
                      (b) => b.getExercises
                        ..meta = (result?.getExercises.meta ??
                                previous.getExercises.meta)!
                            .toBuilder()
                        ..items.addAll(result?.getExercises.items ?? []),
                    ) ??
                    result,
            );
            return getCategoriesReq;
          }
          return null;
        },
        refreshRequest: () {
          getCategoriesReq = getCategoriesReq.rebuild(
            (b) => b
              ..vars.queryParams.page = 1
              ..updateResult = ((previous, result) => result),
          );
          return getCategoriesReq;
        },
        builder: (context, response, error) {
          if ((response?.hasErrors == true ||
                  response?.data?.getExercises.meta?.itemCount == 0) &&
              getCategoriesReq.vars.queryParams.page != 1) {
            getCategoriesReq = getCategoriesReq.rebuild(
              (b) => b..vars.queryParams.page = b.vars.queryParams.page! - 1,
            );
          }

          if (response?.hasErrors == true) {
            return FitnessError(response: response);
          }

          if (response?.loading ?? false) {
            return ListView.separated(
              itemCount: 3,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemBuilder: (context, index) {
                // return const ShimmerRemoteTile();
                return const SizedBox();
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
              title: i18n.common_NotFound,
            );
          }

          return ListView.separated(
            itemCount: exercises!.length + (hasMoreData ? 1 : 0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemBuilder: (context, index) {
              final item = exercises[index];
              return ExerciseItem(
                exercise: item,
                handleDelete: () => handleDelete(item),
                handleEdit: () => goToUpsertPage(item),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
