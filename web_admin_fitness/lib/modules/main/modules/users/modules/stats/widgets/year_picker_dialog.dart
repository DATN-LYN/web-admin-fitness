import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/themes/app_colors.dart';
import '../../../../../../../global/widgets/elevated_button_opacity.dart';

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

    void showDialogPicker() {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SfDateRangePicker(
                      view: DateRangePickerView.decade,
                      selectionColor: AppColors.primaryBold,
                      todayHighlightColor: AppColors.primaryBold,
                      allowViewNavigation: false,
                      initialSelectedDate: selectedDate,
                      onSelectionChanged: (date) {
                        setState(() {
                          selectedDate = date.value as DateTime;
                        });
                      },
                      // selectableDayPredicate: (DateTime val) =>
                      //     !widget.excludeWeekDay.contains(val.weekday),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButtonOpacity(
                            onTap: () {
                              context.popRoute();
                              widget.onChanged(null);
                            },
                            color: AppColors.grey6,
                            label: i18n.button_Cancel,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButtonOpacity(
                            onTap: () {
                              context.popRoute();
                              widget.onChanged(selectedDate);
                            },
                            label: i18n.button_Done,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }

    return InputDecorator(
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down_sharp,
          size: 30,
          color: AppColors.grey1,
        ),
      ),
      child: InkWell(
        child: Text(selectedDate.year.toString()),
        onTap: () => showDialogPicker(),
      ),
    );
  }
}
