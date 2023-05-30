import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart';
import 'package:web_admin_fitness/global/models/exercise_filter_data.dart';
import 'package:web_admin_fitness/modules/main/modules/exercises/widgets/program_selector.dart';

import '../../../../../../../../../../../global/gen/i18n.dart';
import '../../../../../../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../../../../../../global/widgets/filter/filter_text_field.dart';

class ExerciseSearchBar extends StatefulWidget {
  const ExerciseSearchBar({
    super.key,
    required this.onChanged,
    required this.request,
    required this.initialFilter,
    required this.searchField,
  });

  final ValueChanged<GGetExercisesReq> onChanged;
  final GGetExercisesReq request;
  final ExerciseFilterData initialFilter;
  final String searchField;

  @override
  State<ExerciseSearchBar> createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  late ExerciseFilterData filter = widget.initialFilter;

  void handleFilter(ExerciseFilterData filterData) {
    filter = filterData;
    final newFilters = widget.request.vars.queryParams.filters?.toList() ?? [];

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
    newFilters.removeWhere((e) => e.field == 'Exercise.programId');
    if (filterData.program != null) {
      newFilters.add(
        GFilterDto(
          (b) => b
            ..field = 'Exercise.programId'
            ..operator = GFILTER_OPERATOR.eq
            ..data = filterData.program!.id,
        ),
      );
    }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: ProgramSelector(
            initial: filter.program != null ? [filter.program!] : [],
            onChanged: (options) {
              setState(() {
                filter = filter.copyWith(program: options.first.value);
              });
              handleFilter(filter);
            },
          ),
        ),
        const SizedBox(height: 12),
        FilterTextField(
          hintText: i18n.exercises_SearchHint,
          onTextChange: (text) => handleFilter(
            filter.copyWith(keyword: text),
          ),
        ),
      ],
    );
  }
}
