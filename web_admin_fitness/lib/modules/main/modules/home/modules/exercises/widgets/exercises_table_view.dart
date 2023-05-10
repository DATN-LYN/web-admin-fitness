import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/gen/assets.gen.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/utils/duration_time.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/routers/app_router.dart';
import '../helper/exercise_helper.dart';

class ExercisesTableView extends StatefulWidget {
  const ExercisesTableView({
    super.key,
    required this.getExercisesReq,
    required this.onRequestChanged,
  });

  final GGetExercisesReq getExercisesReq;
  final Function(GGetExercisesReq) onRequestChanged;

  @override
  State<ExercisesTableView> createState() => _ExercisesTableViewState();
}

class _ExercisesTableViewState extends State<ExercisesTableView>
    with ClientMixin {
  String? orderBy;
  bool loading = false;

  void handleOrderBy(String fieldName) {
    if (orderBy == 'Exercise.$fieldName:DESC') {
      setState(() => orderBy = 'Exercise.$fieldName:ASC');
    } else {
      setState(() => orderBy = 'Exercise.$fieldName:DESC');
    }

    widget.onRequestChanged(
      widget.getExercisesReq.rebuild(
        (b) => b
          ..vars.queryParams.orderBy = b.vars.queryParams.orderBy = orderBy
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  Widget sortButton(String fieldName) {
    return InkWell(
      onTap: () => handleOrderBy(fieldName),
      child: orderBy == 'Exercise.$fieldName:DESC'
          ? Assets.icons.icSortDown.svg(width: 10, height: 10)
          : orderBy == 'Exercise.$fieldName:ASC'
              ? Assets.icons.icSortUpper.svg(width: 10, height: 10)
              : Assets.icons.icSort.svg(width: 12, height: 12),
    );
  }

  void refreshHandler() {
    widget.onRequestChanged(
      widget.getExercisesReq.rebuild(
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
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    var request = widget.getExercisesReq;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
      child: DataTableBuilder(
        loading: loading,
        client: client,
        request: request,
        meta: (response) {
          return response?.data?.getExercises.meta;
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
          final data = response?.data?.getExercises;
          final exercises = data?.items?.toList() ?? <GExercise>[];

          final dataSource = TableDataSource<GExercise>(
            tableData: exercises,
            columnItems: [
              TableColumn(
                label: i18n.common_ImageUrl,
                minimumWidth: 380,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('imgUrl'),
                cellBuilder: (e) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        ShimmerImage(
                          imageUrl: e.imgUrl ?? '',
                          height: 100,
                          width: 120,
                          borderRadius: BorderRadius.circular(12),
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
              // TableColumn(
              //   label: i18n.common_Id,
              //   minimumWidth: 220,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   itemValue: (e) => e.id,
              // ),
              TableColumn(
                label: i18n.common_Name,
                itemValue: (e) => e.name,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('name'),
              ),
              TableColumn(
                label: i18n.programs_Calo,
                minimumWidth: 150,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('calo'),
                itemValue: (e) => e.calo.toString(),
              ),
              TableColumn(
                label: i18n.common_Duration,
                minimumWidth: 150,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('duration'),
                itemValue: (e) => DurationTime.totalDurationFormat(
                  Duration(
                    seconds: e.duration!.toInt(),
                  ),
                ),
              ),
              TableColumn(
                label: i18n.exercises_VideoUrl,
                minimumWidth: 300,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('videoUrl'),
                itemValue: (e) => e.videoUrl,
              ),
              TableColumn(
                label: i18n.exercises_ProgramId,
                minimumWidth: 220,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('programId'),
                itemValue: (e) => e.programId,
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
                        tooltip: i18n.button_Edit,
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
