import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../../../../global/utils/constants.dart';
import '../../../../../global/widgets/fitness_empty.dart';
import '../../../../../global/widgets/fitness_error.dart';
import '../../../../../global/widgets/infinity_list.dart';
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
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.page = 1
      ..vars.queryParams.orderBy = 'Program.name'
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
  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return Dialog(
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
                handleDelete: () {},
                handleEdit: () {},
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
          );
        },
      ),
    );
  }
}
