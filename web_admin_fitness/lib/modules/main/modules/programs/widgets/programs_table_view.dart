import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/extensions/body_part_extension.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/extensions/workout_level_extension.dart';
import 'package:web_admin_fitness/global/gen/assets.gen.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/routers/app_router.dart';
import '../helper/program_helper.dart';

class ProgramsTableView extends StatefulWidget {
  const ProgramsTableView({
    super.key,
    required this.getProgramsReq,
    required this.onRequestChanged,
  });

  final GGetProgramsReq getProgramsReq;
  final Function(GGetProgramsReq) onRequestChanged;

  @override
  State<ProgramsTableView> createState() => _ProgramsTableViewState();
}

class _ProgramsTableViewState extends State<ProgramsTableView>
    with ClientMixin {
  String? orderBy;
  bool loading = false;

  void handleOrderBy(String fieldName) {
    if (orderBy == 'Program.$fieldName:DESC') {
      setState(() => orderBy = 'Program.$fieldName:ASC');
    } else {
      setState(() => orderBy = 'Program.$fieldName:DESC');
    }

    widget.onRequestChanged(
      widget.getProgramsReq.rebuild(
        (b) => b
          ..vars.queryParams.orderBy = b.vars.queryParams.orderBy = orderBy
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  Widget sortButton(String fieldName) {
    return InkWell(
      onTap: () => handleOrderBy(fieldName),
      child: orderBy == 'Program.$fieldName:DESC'
          ? Assets.icons.icSortDown.svg(width: 10, height: 10)
          : orderBy == 'Program.$fieldName:ASC'
              ? Assets.icons.icSortUpper.svg(width: 10, height: 10)
              : Assets.icons.icSort.svg(width: 12, height: 12),
    );
  }

  void refreshHandler() {
    widget.onRequestChanged(
      widget.getProgramsReq.rebuild(
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
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    var request = widget.getProgramsReq;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
      child: DataTableBuilder(
        loading: loading,
        client: client,
        request: request,
        meta: (response) {
          return response?.data?.getPrograms.meta;
        },
        changeLimitRequest: (response, limit) {
          request = request.rebuild(
            (b) => b..vars.queryParams.limit = limit.toDouble(),
          );
          return request;
        },
        changePageRequest: (response, page) {
          request = request.rebuild(
            (b) => b..vars.queryParams.page = page.toDouble(),
          );
          return request;
        },
        builder: (context, response, error) {
          final data = response?.data?.getPrograms;
          final programs = data?.items?.toList() ?? <GProgram>[];

          final dataSource = TableDataSource<GProgram>(
            tableData: programs,
            columnItems: [
              TableColumn(
                label: i18n.common_ImageUrl,
                minimumWidth: 350,
                columnWidthMode: ColumnWidthMode.fill,
                cellBuilder: (e) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        ShimmerImage(
                          imageUrl: e.imgUrl ?? '',
                          height: 100,
                          width: 120,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e.imgUrl ?? '_',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              TableColumn(
                label: i18n.common_Name,
                itemValue: (e) => e.name,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('name'),
              ),
              TableColumn(
                label: i18n.common_Level,
                minimumWidth: 130,
                columnWidthMode: ColumnWidthMode.fill,
                cellBuilder: (e) {
                  return Tag(
                    text: e.level!.label(i18n),
                    color: e.level!.color(),
                  );
                },
              ),
              TableColumn(
                  label: i18n.programs_BodyPart,
                  minimumWidth: 150,
                  columnWidthMode: ColumnWidthMode.fill,
                  cellBuilder: (e) {
                    return Text(
                      e.bodyPart!.label(i18n),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
              TableColumn(
                label: i18n.programs_Description,
                minimumWidth: 220,
                columnWidthMode: ColumnWidthMode.fill,
                itemValue: (e) => e.description.toString(),
              ),
              TableColumn(
                label: i18n.upsertProgram_Category,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                align: Alignment.center,
                cellBuilder: (e) {
                  return GestureDetector(
                    onTap: () => context.pushRoute(
                      CategoryUpsertRoute(category: e.category),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShimmerImage(
                          height: 70,
                          width: 70,
                          imageUrl: e.category?.imgUrl ?? '',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          e.category?.name ?? '_',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  );
                },
              ),
              TableColumn(
                label: i18n.common_Actions,
                align: Alignment.center,
                width: 125,
                cellBuilder: (e) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () => goToUpsertPage(e),
                        icon: const Icon(Icons.edit),
                        color: AppColors.grey4,
                        tooltip: i18n.common_ViewDetail,
                      ),
                      IconButton(
                        onPressed: () => handleDelete(e),
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        tooltip: i18n.button_Delete,
                      ),
                    ],
                  );
                },
              ),
            ],
          );

          if (programs.isEmpty &&
              response?.hasErrors == false &&
              response?.loading == false) {
            return FitnessEmpty(
              title: i18n.common_NotFound,
            );
          }

          return SfDataGrid(
            source: dataSource,
            shrinkWrapRows: true,
            rowHeight: 125,
            headerRowHeight: 42,
            footerFrozenColumnsCount: 1,
            headerGridLinesVisibility: GridLinesVisibility.none,
            horizontalScrollPhysics: const ClampingScrollPhysics(),
            columns: dataSource.buildColumns(),
            columnWidthMode: ColumnWidthMode.fill,
          );
        },
      ),
    );
  }
}
