import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/themes/app_colors.dart';

class MonthPickerDialog extends StatefulWidget {
  const MonthPickerDialog({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final Function(DateTime?) onChanged;
  final DateTime? initialValue;

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late DateTime selectedDate = widget.initialValue ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final scrW = MediaQuery.of(context).size.width;

    void showDialogPicker() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: min(400, scrW * 0.8),
              height: min(400, scrW * 0.8),
              padding: const EdgeInsets.all(16),
              child: SfDateRangePicker(
                view: DateRangePickerView.year,
                selectionColor: AppColors.primaryBold,
                todayHighlightColor: AppColors.primaryBold,
                allowViewNavigation: false,
                showNavigationArrow: true,
                initialDisplayDate: widget.initialValue ?? DateTime.now(),
                initialSelectedDate: widget.initialValue ?? DateTime.now(),
                onSelectionChanged: (date) {
                  setState(() {
                    selectedDate = date.value as DateTime;
                  });
                  context.popRoute();
                  widget.onChanged(selectedDate);
                },
              ),
            ),
          );
        },
      );
    }

    return InputDecorator(
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: AppColors.grey4,
        ),
      ),
      child: InkWell(
        onTap: showDialogPicker,
        child: Text('${selectedDate.month} / ${selectedDate.year}'),
      ),
    );
  }
}
