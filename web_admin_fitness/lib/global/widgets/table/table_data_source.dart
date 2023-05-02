import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../themes/app_colors.dart';
import 'table_column.dart';
import 'table_column_label.dart';

class TableDataSource<T> extends DataGridSource {
  TableDataSource({
    required this.columnItems,
    this.rowsPerPage = 16,
    required this.tableData,
  }) {
    _dataGridRows = genDataGridRow();
  }

  final int rowsPerPage;
  final List<TableColumn<T>> columnItems;
  List<T> tableData = [];
  List<DataGridRow> _dataGridRows = [];

  List<DataGridRow> genDataGridRow() {
    return tableData
        .map((e) => DataGridRow(
              cells: columnItems
                  .map((c) => DataGridCell<T>(
                        columnName: c.label,
                        value: e,
                      ))
                  .toList(),
            ))
        .toList();
  }

  List<GridColumn> buildColumns() {
    return columnItems.map((e) {
      if (e.build != null) return e.build!();
      return GridColumn(
        columnName: e.label,
        minimumWidth: e.minimumWidth,
        maximumWidth: e.maximumWidth,
        columnWidthMode: e.columnWidthMode,
        width: e.width,
        label: GridColumnLabel(
          e.label,
          action: e.action,
        ),
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // final index = effectiveRows.indexOf(row);
    final cells = row.getCells();
    return DataGridRowAdapter(
      // color: index % 2 == 0 ? Colors.white : Palette.primary90,
      cells: List.generate(
        cells.length,
        (index) {
          final col = columnItems[index];
          return Container(
            alignment: col.align,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: col.cellBuilder == null
                ? SelectableText(
                    col.itemValue!(cells[index].value) ?? '_',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 18 / 14,
                      color: AppColors.grey1,
                    ),
                  )
                : col.cellBuilder!(cells[index].value),
          );
        },
      ),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    return true;
  }
}
