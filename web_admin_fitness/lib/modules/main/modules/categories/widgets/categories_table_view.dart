import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';

import '../../../../../global/gen/i18n.dart';

class CategoriesTableView extends StatefulWidget {
  const CategoriesTableView({super.key});

  @override
  State<CategoriesTableView> createState() => _CategoriesTableViewState();
}

class _CategoriesTableViewState extends State<CategoriesTableView>
    with ClientMixin {
  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    return DataTableBuilder(
      client: client,
      request: GUpsertInBoxRe,
      builder: (context, response, error) {
        final dataSource = TableDataSource(
          columnItems: [TableColumn(label: label)],
          tableData: tableData,
        );

        return SfDataGrid(
          source: dataSource,
          shrinkWrapRows: true,
          rowHeight: 64,
          headerRowHeight: 42,
          footerFrozenColumnsCount: 1,
          headerGridLinesVisibility: GridLinesVisibility.none,
          horizontalScrollPhysics: const ClampingScrollPhysics(),
          columns: dataSource.buildColumns(),
          columnWidthMode: ColumnWidthMode.fill,
        );
      },
      changeLimitRequest: (data, limit) {},
      changePageRequest: (data, page) {},
      meta: (data) {},
    );
  }
}
