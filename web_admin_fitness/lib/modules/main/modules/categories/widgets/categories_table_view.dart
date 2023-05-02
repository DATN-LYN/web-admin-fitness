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

import '../../../../../global/gen/i18n.dart';

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

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    var request = widget.getCategoriesReq;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
      child: DataTableBuilder(
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
                label: 'id',
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                itemValue: (e) => e.id,
              ),
              TableColumn(
                label: 'Name',
                itemValue: (e) => e.name,
                minimumWidth: 100,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('name'),
              ),
              TableColumn(
                  label: 'Image URL',
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          const SizedBox(width: 6),
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
                  }),
              TableColumn(
                label: 'Actions',
                align: Alignment.center,
                width: 110,
                cellBuilder: (e) {
                  return IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove_red_eye),
                    color: AppColors.grey4,
                    tooltip: 'View Detail',
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
