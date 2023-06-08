import 'package:auto_route/auto_route.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../../../../global/utils/constants.dart';
import '../../../../../global/widgets/fitness_empty.dart';
import '../../../../../global/widgets/fitness_error.dart';
import '../../../../../global/widgets/infinity_list.dart';
import '../../../../../global/widgets/shimmer_program_item.dart';
import '../../programs/widgets/program_item.dart';

class ProgramListDialog extends StatefulWidget {
  const ProgramListDialog({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  State<ProgramListDialog> createState() => _ProgramListDialogState();
}

class _ProgramListDialogState extends State<ProgramListDialog>
    with ClientMixin {
  late var getProgramsReq = GGetProgramsReq(
    (b) => b
      ..requestId = '@getProgramsRequestId'
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.page = 1
      ..vars.queryParams.filters = ListBuilder(
        [
          GFilterDto(
            (b) => b
              ..data = widget.categoryId
              ..field = 'Program.categoryId'
              ..operator = GFILTER_OPERATOR.eq,
          )
        ],
      ),
  );

  void onChanged(String? value) {
    getProgramsReq = getProgramsReq.rebuild(
      (p0) => p0
        ..vars.queryParams.page = 1
        ..updateResult = ((previous, result) => result)
        ..vars.queryParams.filters = ListBuilder(
          [
            GFilterDto(
              (b) => b
                ..data = widget.categoryId
                ..field = 'Program.categoryId'
                ..operator = GFILTER_OPERATOR.eq,
            ),
            GFilterDto(
              (b) => b
                ..field = 'Program.name'
                ..data = value
                ..operator = GFILTER_OPERATOR.like,
            ),
          ],
        ),
    );
    client.requestController.add(getProgramsReq);
  }

  void goToProgramUpsert() {
    context.pushRoute(
      MainRoute(
        children: [
          ProgramsRoute(
            children: [
              const ProgramsManagerRoute(),
              ProgramUpsertRoute(
                initialCategoryId: widget.categoryId,
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
                request: getProgramsReq,
                loadMoreRequest: (response) {
                  final data = response?.data?.getPrograms;
                  if (data != null &&
                      data.meta!.currentPage!.toDouble() <
                          data.meta!.totalPages!.toDouble()) {
                    getProgramsReq = getProgramsReq.rebuild(
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
                  if (response?.hasErrors == true) {
                    return FitnessError(response: response);
                  }
                  if (response?.loading ?? false) {
                    return ListView.separated(
                      itemCount: 3,
                      padding: const EdgeInsets.all(0),
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
                      title: i18n.upsertCategory_ProgramEmpty,
                    );
                  }

                  return Column(
                    children: [
                      TextFormField(
                        onChanged: (value) => onChanged(value),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: programs!.length + (hasMoreData ? 1 : 0),
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          itemBuilder: (context, index) {
                            final item = programs[index];
                            return ProgramItem(
                              program: item,
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
              onPressed: goToProgramUpsert,
              child: Text(i18n.upsertCategory_AddNewProgram),
            ),
          ],
        ),
      ),
    );
  }
}
