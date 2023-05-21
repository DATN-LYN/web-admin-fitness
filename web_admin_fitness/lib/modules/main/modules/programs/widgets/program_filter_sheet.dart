import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/enums/workout_level.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/models/program_filter_data.dart';
import 'package:web_admin_fitness/global/widgets/filter/filter_sheet_wrapper.dart';

import '../../../../../../../global/themes/app_colors.dart';

class ProgramFilterSheet extends StatefulWidget {
  const ProgramFilterSheet({
    super.key,
    required this.programFilterData,
  });

  final ProgramFilterData programFilterData;

  @override
  State<ProgramFilterSheet> createState() => _ProgramFilterSheetState();
}

class _ProgramFilterSheetState extends State<ProgramFilterSheet> {
  late ProgramFilterData filter = widget.programFilterData;

  void handleClearFilter() {
    setState(() {
      filter = const ProgramFilterData();
    });
  }

  TextStyle get titleStyle => const TextStyle(
        color: AppColors.grey1,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return FilterSheetWrapper(
      onApply: () => context.popRoute(filter),
      onClearAll: handleClearFilter,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            i18n.filter_WorkoutLevel,
            style: titleStyle,
          ),
        ),
        const SizedBox(height: 10),
        ...WorkoutLevel.values.map(
          (e) => CheckboxListTile(
            value: filter.levels.contains(e.value),
            title: Text(e.label(i18n)),
            onChanged: (value) {
              setState(
                () {
                  if (value == true) {
                    filter =
                        filter.copyWith(levels: [...filter.levels, e.value]);
                  } else {
                    filter = filter.copyWith(
                      levels: filter.levels
                          .whereNot((item) => item == e.value)
                          .toList(),
                    );
                  }
                },
              );
            },
          ),
        )
      ],
    );
  }
}
