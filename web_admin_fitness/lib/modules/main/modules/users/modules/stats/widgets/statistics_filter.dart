import 'package:adaptive_selector/adaptive_selector.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:jiffy/jiffy.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_user_stats.req.gql.dart';

import '../../../../../../../global/enums/filter_range_type.dart';
import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../../global/themes/app_colors.dart';
import '../../../models/statistics_filter_data.dart';
import 'month_picker_dialog.dart';
import 'year_picker_dialog.dart';

class StatisticsFilter extends StatefulWidget {
  const StatisticsFilter({
    super.key,
    required this.request,
    required this.onChanged,
    required this.filter,
  });

  final GGetUserStatsReq request;
  final Function(GGetUserStatsReq, StatisticsFilterData) onChanged;
  final StatisticsFilterData filter;

  @override
  State<StatisticsFilter> createState() => _StatisticsFilterState();
}

class _StatisticsFilterState extends State<StatisticsFilter> {
  late var filter = widget.filter;

  void handleFilter(DateTime startDate, DateTime endDate) {
    final newFilters = widget.request.vars.queryParams.filters?.toList() ?? [];
    newFilters.removeWhere((e) => e.field == 'UserStatistics.updatedAt');
    newFilters.addAll(
      [
        GFilterDto(
          (b) => b
            ..data = startDate.toString()
            ..field = 'UserStatistics.updatedAt'
            ..operator = GFILTER_OPERATOR.gt,
        ),
        GFilterDto(
          (b) => b
            ..data = endDate.toString()
            ..field = 'UserStatistics.updatedAt'
            ..operator = GFILTER_OPERATOR.lt,
        ),
      ],
    );

    widget.onChanged(
      widget.request.rebuild(
        (b) => b
          ..vars.queryParams.filters = ListBuilder(newFilters)
          ..updateResult = (previous, result) => result,
      ),
      filter,
    );
  }

  void onFilter() {
    handleFilter(
      filter.rangeType!.startDate(
        month: filter.month,
        year: filter.year,
      )!,
      filter.rangeType!.endDate(
        month: filter.month,
        year: filter.year,
      )!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final options = FilterRangeType.values
        .map(
          (e) => AdaptiveSelectorOption(label: e.label(i18n), value: e),
        )
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        AdaptiveSelector<FilterRangeType>(
          decoration: const InputDecoration(
            filled: true,
            fillColor: AppColors.white,
          ),
          allowClear: false,
          type: SelectorType.menu,
          options: options,
          initial: [
            AdaptiveSelectorOption(
              label: filter.rangeType!.label(i18n),
              value: filter.rangeType!,
            )
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                filter = filter.copyWith(rangeType: value.first.value);
              });
            }
            onFilter();
          },
        ),
        if (filter.rangeType == FilterRangeType.monthly)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: FormBuilderField<int>(
              name: 'month',
              initialValue: Jiffy().month,
              builder: (field) {
                return MonthPickerDialog(
                  initialValue: filter.rangeType?.getFirstDayOfMonth(
                    filter.month ?? Jiffy().month,
                    filter.year ?? Jiffy().year,
                  ),
                  onChanged: (selectedMonth) {
                    if (selectedMonth != null) {
                      setState(() {
                        filter = filter.copyWith(
                          month: selectedMonth.month,
                          year: selectedMonth.year,
                        );
                      });
                      onFilter();
                    }
                  },
                );
              },
            ),
          ),
        if (filter.rangeType == FilterRangeType.yearly)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: FormBuilderField<int>(
              name: 'year',
              initialValue: Jiffy().month,
              builder: (field) {
                return YearPickerDialog(
                  initialValue: filter.rangeType?.getFirstDayOfYear(
                    filter.year ?? Jiffy().year,
                  ),
                  onChanged: (selectedMonth) {
                    if (selectedMonth != null) {
                      setState(() {
                        filter = filter.copyWith(year: selectedMonth.year);
                      });
                      onFilter();
                    }
                  },
                );
              },
            ),
          ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.filter,
    this.isSelected = false,
    required this.onFilter,
  });

  final FilterRangeType filter;
  final bool isSelected;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          onPressed: onFilter,
          style: FilledButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.primaryBold
                : AppColors.primary.withOpacity(0.7),
          ),
          child: Text(
            filter.label(i18n),
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.grey1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
