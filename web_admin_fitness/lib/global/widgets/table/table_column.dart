import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TableColumn<T> {
  TableColumn({
    required this.label,
    this.itemValue,
    this.width = double.nan,
    this.columnWidthMode = ColumnWidthMode.none,
    this.minimumWidth = double.nan,
    this.maximumWidth = double.nan,
    this.align = Alignment.centerLeft,
    this.cellBuilder,
    this.build,
    this.action,
  }) : assert((cellBuilder != null && itemValue == null) ||
            (itemValue != null && cellBuilder == null));

  final String label;
  final ColumnWidthMode columnWidthMode;
  final double minimumWidth;
  final double maximumWidth;
  final Alignment align;
  final double width;
  final Widget Function(T value)? cellBuilder;
  final Widget? action;
  late final GridColumn Function()? build;
  final String? Function(T)? itemValue;
}
