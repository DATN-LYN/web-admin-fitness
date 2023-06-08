import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart';
import 'package:web_admin_fitness/global/models/category_filter_data.dart';

import '../../../../../../../../../../../global/gen/i18n.dart';
import '../../../../../../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../../../../../../global/widgets/filter/filter_text_field.dart';

class CategorySearchBar extends StatefulWidget {
  const CategorySearchBar({
    super.key,
    required this.onChanged,
    required this.request,
    required this.initialFilter,
    this.title,
    required this.searchField,
  });

  final ValueChanged<dynamic> onChanged;
  final GGetCategoriesReq request;
  final CategoryFilterData initialFilter;
  final String? title;
  final String searchField;

  @override
  State<CategorySearchBar> createState() => _CategorySearchBarState();
}

class _CategorySearchBarState extends State<CategorySearchBar> {
  late dynamic filter = widget.initialFilter;

  void handleFilter(dynamic filterData) {
    filter = filterData;
    final newFilters = widget.request.vars.queryParams.filters?.toList() ?? [];

    // filter by schedule mode
    // newFilters.removeWhere((e) => e.field == 'Remote.isSchedule');
    // if (filterData.isSchedule != null) {
    //   newFilters.add(
    //       // GFilterDto(
    //       //   (b) => b
    //       //     ..field = 'Remote.isSchedule'
    //       //     ..operator = GQUERY_OPERATOR.eq
    //       //     ..data = filterData.isSchedule.toString(),
    //       // ),
    //       );
    // }

    // filter by startDate and endDate
    // newFilters.removeWhere((e) => e.field == 'Remote.startDate');
    // newFilters.removeWhere((e) => e.field == 'Remote.endDate');
    // if (filterData.rangeType != null &&
    //     filterData.startDate != null &&
    //     filterData.endDate != null) {
    //   newFilters.addAll([
    // GFilterDto(
    //   (b) => b
    //     ..field = 'Remote.startDate'
    //     ..operator = GQUERY_OPERATOR.gte
    //     ..data = filterData.startDate.toString(),
    // ),
    // GFilterDto(
    //   (b) => b
    //     ..field = 'Remote.endDate'
    //     ..operator = GQUERY_OPERATOR.lte
    //     ..data = filterData.endDate.toString(),
    // )
    //   ]);
    // }

    // filter by keyword
    // newFilters.removeWhere((e) => e.field == widget.searchMode.key);
    if (filterData.keyword?.isNotEmpty ?? false) {
      newFilters.add(
        GFilterDto(
          (b) => b
            ..field = widget.searchField
            ..operator = GFILTER_OPERATOR.like
            ..data = filterData.keyword,
        ),
      );
    } else {
      newFilters.clear();
    }

    // filter by status
    // newFilters.removeWhere((e) => e.field == 'Remote.status');
    // if (filterData.status.isNotEmpty) {
    //   newFilters.add(
    //     GFilterDto((b) => b
    //       ..field = 'Remote.status'
    //       ..operator = GFILTER_OPERATOR.eq
    //       ..data = filterData.status.map((e) => e.name).join(',')),
    //   );
    // }

    widget.onChanged(widget.request.rebuild(
      (b) => b
        ..vars.queryParams.page = 1
        ..vars.queryParams.filters = ListBuilder(newFilters)
        ..updateResult = (previous, result) => result,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FilterTextField(
            hintText: 'Search',
            onTextChange: (text) => handleFilter(
              filter.copyWith(keyword: text),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
