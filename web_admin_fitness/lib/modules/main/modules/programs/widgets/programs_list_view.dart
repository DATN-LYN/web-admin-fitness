import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';

import '../../../../../../../global/routers/app_router.dart';
import '../../../../../global/widgets/shimmer_program_item.dart';
import '../helper/program_helper.dart';
import 'program_item.dart';

class ProgramsListView extends StatefulWidget {
  const ProgramsListView({
    super.key,
    required this.request,
    required this.onRequestChanged,
  });

  final GGetProgramsReq request;
  final Function(GGetProgramsReq) onRequestChanged;

  @override
  State<ProgramsListView> createState() => _ProgramsListViewState();
}

class _ProgramsListViewState extends State<ProgramsListView> with ClientMixin {
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

  void handleDelete(GProgram program) async {
    setState(() => loading = true);
    await ProgramHelper().handleDelete(context, program);
    refreshHandler();
    setState(() => loading = false);
  }

  void goToUpsertPage(GProgram program) {
    context.pushRoute(ProgramUpsertRoute(program: program)).then(
      (value) {
        if (value != null) {
          refreshHandler();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var getProgramsReq = widget.request;
    final i18n = I18n.of(context)!;

    return LoadingOverlay(
      loading: loading,
      isDark: false,
      child: InfinityList(
        client: client,
        request: widget.request,
        loadMoreRequest: (response) {
          final data = response?.data?.getPrograms;
          if (data != null &&
              data.meta!.currentPage!.toDouble() <
                  data.meta!.totalPages!.toDouble()) {
            getProgramsReq = widget.request.rebuild(
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
                return const ShimmerProgramItem();
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
            );
          }
          final data = response!.data!.getPrograms;
          final hasMoreData = data.meta!.currentPage!.toDouble() <
              data.meta!.totalPages!.toDouble();
          final programs = data.items;

          if (programs?.isEmpty == true) {
            return FitnessEmpty(
              title: i18n.common_NotFound,
            );
          }

          return ListView.separated(
            itemCount: programs!.length + (hasMoreData ? 1 : 0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemBuilder: (context, index) {
              final item = programs[index];
              return ProgramItem(
                program: item,
                handleDelete: () => handleDelete(item),
                handleEdit: () => goToUpsertPage(item),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
          );
        },
      ),
    );
  }
}
