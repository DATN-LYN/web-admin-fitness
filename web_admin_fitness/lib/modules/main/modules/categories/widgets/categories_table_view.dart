import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/gen/assets.gen.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/routers/app_router.dart';
import '../helper/category_helper.dart';

class CategoriesTableView extends StatefulWidget {
  const CategoriesTableView({
    super.key,
    required this.getCategoriesReq,
    required this.onRequestChanged,
  });

  final GGetCategoriesReq getCategoriesReq;
  final Function(GGetCategoriesReq) onRequestChanged;

  @override
  State<CategoriesTableView> createState() => _CategoriesTableViewState();
}

class _CategoriesTableViewState extends State<CategoriesTableView>
    with ClientMixin {
  String? orderBy;
  bool loading = false;

  void handleOrderBy(String fieldName) {
    if (orderBy == 'Category.$fieldName:DESC') {
      setState(() => orderBy = 'Category.$fieldName:ASC');
    } else {
      setState(() => orderBy = 'Category.$fieldName:DESC');
    }

    widget.onRequestChanged(
      widget.getCategoriesReq.rebuild(
        (b) => b
          ..vars.queryParams.orderBy = b.vars.queryParams.orderBy = orderBy
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  Widget sortButton(String fieldName) {
    return InkWell(
      onTap: () => handleOrderBy(fieldName),
      child: orderBy == 'Category.$fieldName:DESC'
          ? Assets.icons.icSortDown.svg(width: 10, height: 10)
          : orderBy == 'Category.$fieldName:ASC'
              ? Assets.icons.icSortUpper.svg(width: 10, height: 10)
              : Assets.icons.icSort.svg(width: 12, height: 12),
    );
  }

  void refreshHandler() {
    widget.onRequestChanged(
      widget.getCategoriesReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  void goToUpsertPage(GCategory category) {
    context.pushRoute(CategoryUpsertRoute(category: category)).then(
      (value) {
        if (value != null) {
          refreshHandler();
        }
      },
    );
  }

  void handleDelete(GCategory category) async {
    setState(() => loading = true);
    await CategoryHelper().handleDelete(context, category);
    refreshHandler();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 20.0);
    final i18n = I18n.of(context)!;
    var request = widget.getCategoriesReq;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
      child: DataTableBuilder(
        loading: loading,
        client: client,
        request: request,
        meta: (response) {
          return response?.data?.getCategories.meta;
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
          final data = response?.data?.getCategories;
          final categories = data?.items?.toList() ?? <GCategory>[];

          final dataSource = TableDataSource<GCategory>(
            tableData: categories,
            columnItems: [
              TableColumn(
                label: i18n.common_ImageUrl,
                minimumWidth: 450,
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
              //   label: i18n.common_Id,
              //   minimumWidth: 200,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   itemValue: (e) => e.id,
              // ),
              TableColumn(
                label: i18n.common_Name,
                itemValue: (e) => e.name,
                minimumWidth: 220,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('name'),
              ),
              TableColumn(
                label: i18n.common_Actions,
                align: Alignment.center,
                width: 130,
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
