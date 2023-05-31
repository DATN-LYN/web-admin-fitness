import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/models/exercise_filter_data.dart';
import 'package:web_admin_fitness/global/widgets/filter/filter_sheet_wrapper.dart';
import 'package:web_admin_fitness/modules/main/modules/exercises/widgets/program_selector.dart';

import '../../../../../../../global/themes/app_colors.dart';

class ExerciseFilterSheet extends StatefulWidget {
  const ExerciseFilterSheet({
    super.key,
    required this.exerciseFilterData,
  });

  final ExerciseFilterData exerciseFilterData;

  @override
  State<ExerciseFilterSheet> createState() => _ExerciseFilterSheetState();
}

class _ExerciseFilterSheetState extends State<ExerciseFilterSheet> {
  late ExerciseFilterData filter = widget.exerciseFilterData;
  var formKey = GlobalKey();

  void handleClearFilter() {
    setState(() {
      filter = const ExerciseFilterData();
      formKey = GlobalKey();
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
      key: formKey,
      onApply: () => context.popRoute(filter),
      onClearAll: handleClearFilter,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            i18n.main_Programs,
            style: titleStyle,
          ),
        ),
        const SizedBox(height: 16),
        ProgramSelector(
          initial: filter.program != null ? [filter.program!] : [],
          onChanged: (options) {
            setState(() {
              filter = filter.copyWith(program: options.first.value);
            });
          },
        ),
      ],
    );
  }
}
