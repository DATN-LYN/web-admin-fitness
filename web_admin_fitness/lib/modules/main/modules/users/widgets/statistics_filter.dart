import 'package:built_collection/built_collection.dart';
import 'package:fitness_app/global/data/models/statistics_filter_data.dart';
import 'package:fitness_app/global/enums/filter_range_type.dart';
import 'package:fitness_app/global/graphql/query/__generated__/query_get_my_stats.req.gql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../../global/enums/filter_range_type.dart';
import '../../../../../global/gen/i18n.dart';
import '../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../global/providers/me_provider.dart';
import '../../../../../global/themes/app_colors.dart';
import '../models/statistics_filter_data.dart';
import 'month_picker_dialog.dart';
import 'year_picker_dialog.dart';

class StatisticsFilter extends StatefulWidget {
  const StatisticsFilter({
    required this.request,
    required this.onChanged,
    required this.filter,
    super.key,
  });

  final GGetMyStatsReq request;
  final Function(GGetMyStatsReq, StatisticsFilterData) onChanged;
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
            ..data = filter.rangeType
                ?.startDate(month: filter.month, year: filter.year)
                .toString()
            ..field = 'UserStatistics.updatedAt'
            ..operator = GFILTER_OPERATOR.gt,
        ),
        GFilterDto(
          (b) => b
            ..data = filter.rangeType
                ?.endDate(month: filter.month, year: filter.year)
                .toString()
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
    final now = DateTime.now();

    handleFilter(
      filter.rangeType?.startDate(month: filter.month, year: filter.year) ??
          now,
      filter.rangeType?.endDate(month: filter.month, year: filter.year) ?? now,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            ...FilterRangeType.values.map(
              (rangeType) {
                return FilterButton(
                  isSelected: filter.rangeType == rangeType,
                  filter: rangeType,
                  onFilter: () {
                    setState(() {
                      filter = filter.copyWith(rangeType: rangeType);
                    });
                    onFilter();
                  },
                );
              },
            ),
          ],
        ),
        if (filter.rangeType == FilterRangeType.monthly)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: FormBuilderField<int>(
              name: 'month',
              initialValue: Jiffy().month,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 30,
                ),
              ),
              builder: (field) {
                return MonthPickerDialog(
                  initialValue: filter.rangeType?.getFirstDayOfMonth(
                    filter.month ?? Jiffy().month,
                  ),
                  onChanged: (selectedMonth) {
                    if (selectedMonth != null) {
                      setState(() {
                        filter = filter.copyWith(month: selectedMonth.month);
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
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 30,
                ),
              ),
              builder: (field) {
                return const SizedBox();
                // return YearPickerDialog(
                //   initialValue: filter.rangeType?.getFirstDayOfMonth(
                //     filter.month ?? Jiffy().month,
                //   ),
                //   onChanged: (selectedMonth) {
                //     if (selectedMonth != null) {
                //       setState(() {
                //         filter = filter.copyWith(year: selectedMonth.year);
                //       });
                //       onFilter();
                //     }
                //   },
                // );
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
