import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/program_item.dart';

class ProgramsListView extends StatelessWidget with ClientMixin {
  ProgramsListView({
    super.key,
    required this.request,
  });

  final GGetProgramsReq request;

  @override
  Widget build(BuildContext context) {
    var getProgramsReq = request;
    final i18n = I18n.of(context)!;

    return InfinityList(
      client: client,
      request: request,
      loadMoreRequest: (response) {
        final data = response?.data?.getPrograms;
        if (data != null &&
            data.meta!.currentPage!.toDouble() <
                data.meta!.totalPages!.toDouble()) {
          getProgramsReq = request.rebuild(
            (b) => b
              ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
              ..updateResult = (previous, result) =>
                  previous?.rebuild(
                    (b) => b.getPrograms
                      ..meta = (result?.getPrograms.meta ??
                              previous.getPrograms.meta)!
                          .toBuilder()
                      ..items.addAll(result?.getPrograms.items ?? []),
                  ) ??
                  result,
          );
          return getProgramsReq;
        }
        return null;
      },
      refreshRequest: () {
        getProgramsReq = getProgramsReq.rebuild(
          (b) => b
            ..vars.queryParams.page = 1
            ..updateResult = ((previous, result) => result),
        );
        return getProgramsReq;
      },
      builder: (context, response, error) {
        if ((response?.hasErrors == true ||
                response?.data?.getPrograms.meta?.itemCount == 0) &&
            getProgramsReq.vars.queryParams.page != 1) {
          getProgramsReq = getProgramsReq.rebuild(
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
        final data = response!.data!.getPrograms;
        final hasMoreData = data.meta!.currentPage!.toDouble() <
            data.meta!.totalPages!.toDouble();
        final categories = data.items;

        if (categories?.isEmpty == true) {
          return FitnessEmpty(
            title: i18n.common_NotFound,
          );
        }

        return ListView.separated(
          itemCount: categories!.length + (hasMoreData ? 1 : 0),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemBuilder: (context, index) {
            final item = categories[index];
            return ProgramItem(program: item);
          },
          separatorBuilder: (_, __) => const SizedBox(height: 16),
        );
      },
    );
  }
}
