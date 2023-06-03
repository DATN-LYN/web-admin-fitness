import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/themes/app_colors.dart';

class YearPickerDialog extends StatefulWidget {
  const YearPickerDialog({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final Function(DateTime?) onChanged;
  final DateTime? initialValue;

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  late DateTime selectedDate = widget.initialValue ?? DateTime.now();
  String? value;
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
              child: YearPicker(
                firstDate: DateTime(2000, 1, 1),
                lastDate: DateTime.now(),
                selectedDate: selectedDate,
                initialDate: selectedDate,
                onChanged: (date) {
                  setState(() {
                    selectedDate = date;
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
        child: Text(selectedDate.year.toString()),
        onTap: () => showDialogPicker(),
      ),
    );
  }
}
