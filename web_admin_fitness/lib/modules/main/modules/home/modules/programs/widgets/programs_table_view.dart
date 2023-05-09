import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/enums/workout_body_part.dart';
import 'package:web_admin_fitness/global/enums/workout_level.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/gen/assets.gen.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/programs/helper/program_helper.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/routers/app_router.dart';

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

  void handleDelete(GProgram exercise) async {
    setState(() => loading = true);
    await ProgramHelper().handleDelete(context, exercise);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    var request = widget.getProgramsReq;

    void goToUpsertPage(GProgram program) {
      context.pushRoute(ProgramUpsertRoute(program: program)).then(
        (value) {
          if (value != null) {
            request = request.rebuild(
              (b) => b
                ..vars.queryParams.page = 1
                ..updateResult = ((previous, result) => result),
            );

            client.requestController.add(request);
          }
        },
      );
    }

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
                label: i18n.common_Id,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                itemValue: (e) => e.id,
              ),
              TableColumn(
                label: i18n.common_Name,
                itemValue: (e) => e.name,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('name'),
              ),
              TableColumn(
                label: i18n.common_ImageUrl,
                // itemValue: (e) => e.imgUrl,
                minimumWidth: 350,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('imgUrl'),
                cellBuilder: (e) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        ShimmerImage(
                          imageUrl: e.imgUrl ?? '',
                          height: 120,
                          width: 100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(width: 8),
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
              // TableColumn(
              //   label: i18n.programs_Calo,
              //   minimumWidth: 100,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   action: sortButton('calo'),
              //   itemValue: (e) => e.calo.toString(),
              // ),
              // TableColumn(
              //   label: i18n.common_Duration,
              //   minimumWidth: 130,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   action: sortButton('duration'),
              //   itemValue: (e) => e.duration.toString(),
              // ),
              TableColumn(
                label: i18n.common_Level,
                minimumWidth: 130,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('level'),
                cellBuilder: (e) {
                  final level = WorkoutLevel.getLevel(e.level ?? 0);
                  return Tag(
                    text: level.label(i18n),
                    color: level.color(),
                  );
                },
              ),
              TableColumn(
                  label: i18n.programs_BodyPart,
                  minimumWidth: 150,
                  columnWidthMode: ColumnWidthMode.fill,
                  action: sortButton('bodyPart'),
                  cellBuilder: (e) {
                    final bodyPart =
                        WorkoutBodyPart.getBodyPart(e.bodyPart ?? 0);
                    return Text(
                      bodyPart.label(i18n),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
              // TableColumn(
              //   label: i18n.programs_Description,
              //   minimumWidth: 150,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   action: sortButton('description'),
              //   itemValue: (e) => e.calo.toString(),
              // ),
              TableColumn(
                label: i18n.common_Actions,
                align: Alignment.center,
                width: 120,
                cellBuilder: (e) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () => goToUpsertPage(e),
                        icon: const Icon(Icons.visibility),
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

          return SfDataGrid(
            source: dataSource,
            shrinkWrapRows: true,
            rowHeight: 120,
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
