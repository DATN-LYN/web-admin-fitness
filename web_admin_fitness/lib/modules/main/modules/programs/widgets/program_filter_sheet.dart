import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/extensions/body_part_extension.dart';
import 'package:web_admin_fitness/global/extensions/workout_level_extension.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/widgets/filter/filter_sheet_wrapper.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/models/program_filter_data.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/category_selector.dart';

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
  var formKey = GlobalKey();

  void handleClearFilter() {
    setState(() {
      filter = const ProgramFilterData();
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            i18n.filter_WorkoutLevel,
            style: titleStyle,
          ),
        ),
        const SizedBox(height: 10),
        ...GWORKOUT_LEVEL.values.map(
          (e) => CheckboxListTile(
            value: filter.levels.contains(e),
            title: Text(e.label(i18n)),
            onChanged: (value) {
              setState(
                () {
                  if (value == true) {
                    filter = filter.copyWith(levels: [...filter.levels, e]);
                  } else {
                    filter = filter.copyWith(
                      levels:
                          filter.levels.whereNot((item) => item == e).toList(),
                    );
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            i18n.programs_BodyPart,
            style: titleStyle,
          ),
        ),
        const SizedBox(height: 10),
        ...GBODY_PART.values.map(
          (e) => CheckboxListTile(
            value: filter.bodyParts.contains(e),
            title: Text(e.label(i18n)),
            onChanged: (value) {
              setState(
                () {
                  if (value == true) {
                    filter =
                        filter.copyWith(bodyParts: [...filter.bodyParts, e]);
                  } else {
                    filter = filter.copyWith(
                      bodyParts: filter.bodyParts
                          .whereNot((item) => item == e)
                          .toList(),
                    );
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            i18n.main_Categories,
            style: titleStyle,
          ),
        ),
        const SizedBox(height: 16),
        CategorySelector(
          initial: filter.category != null ? [filter.category!] : [],
          onChanged: (options) {
            setState(() {
              filter = filter.copyWith(category: options.first.value);
            });
          },
        ),
      ],
    );
  }
}
