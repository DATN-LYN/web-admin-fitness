import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/modules/main/modules/exercises/widgets/exercise_item.dart';

class ExercisesListView extends StatelessWidget with ClientMixin {
  ExercisesListView({super.key, required this.request});

  final GGetExercisesReq request;

  @override
  Widget build(BuildContext context) {
    var getCategoriesReq = request;

    return InfinityList(
      client: client,
      request: request,
      loadMoreRequest: (response) {
        final data = response?.data?.getExercises;
        if (data != null &&
            data.meta!.currentPage!.toDouble() <
                data.meta!.totalPages!.toDouble()) {
          getCategoriesReq = request.rebuild(
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
        final categories = data.items;

        if (categories?.isEmpty == true) {
          return const FitnessEmpty(
            title: 'Not Found',
          );
        }

        return ListView.separated(
          itemCount: categories!.length + (hasMoreData ? 1 : 0),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemBuilder: (context, index) {
            final item = categories[index];
            return ExerciseItem(exercise: item);
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
        );
      },
    );
  }
}
