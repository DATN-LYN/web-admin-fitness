import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/models/program_filter_data.dart';

import '../../../../../../../../global/gen/i18n.dart';
import '../../../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../../../global/themes/app_colors.dart';
import '../../../../../../../../global/widgets/filter/filter_text_field.dart';
import 'program_filter_sheet.dart';

class ProgramSearchBar extends StatefulWidget {
  const ProgramSearchBar({
    super.key,
    required this.onChanged,
    required this.request,
    required this.initialFilter,
    required this.searchField,
  });

  final ValueChanged<GGetProgramsReq> onChanged;
  final GGetProgramsReq request;
  final ProgramFilterData initialFilter;
  final String searchField;

  @override
  State<ProgramSearchBar> createState() => _ProgramSearchBarState();
}

class _ProgramSearchBarState extends State<ProgramSearchBar> {
  late ProgramFilterData filter = widget.initialFilter;

  void handleFilter(ProgramFilterData filterData) {
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

    // filter by categoryId
    newFilters.removeWhere((e) => e.field == 'Program.categoryId');
    if (filterData.category != null) {
      newFilters.add(
        GFilterDto(
          (b) => b
            ..field = 'Program.categoryId'
            ..operator = GFILTER_OPERATOR.eq
            ..data = filterData.category?.id,
        ),
      );
    } else {
      newFilters.clear();
    }

    // filter by status
    newFilters.removeWhere((e) => e.field == 'Program.level');
    if (filterData.levels.isNotEmpty) {
      newFilters.add(
        GFilterDto(
          (b) => b
            ..field = 'Program.level'
            ..operator = GFILTER_OPERATOR.Gin
            ..data = filterData.levels.map((e) => e).join(','),
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

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FilterTextField(
            hintText: i18n.programs_SearchHint,
            onTextChange: (text) => handleFilter(
              filter.copyWith(keyword: text),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.hardEdge,
          color: AppColors.grey6,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final newFilter = await SideSheet.right(
                body: ProgramFilterSheet(programFilterData: filter),
                context: context,
                width: min(
                  MediaQuery.of(context).size.width * 0.8,
                  400,
                ),
              );

              // * (Optional) show dialog on mobile
              // await showDialog(
              //   context: context,
              //   builder: (context) => Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: Material(
              //       clipBehavior: Clip.hardEdge,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: RemoteFilterSheet(initialFilters: filter),
              //     ),
              //   ),
              // )

              if (newFilter is ProgramFilterData) {
                handleFilter(newFilter);
              }
            },
            icon: const Icon(
              Icons.sort,
              color: AppColors.grey3,
              size: 16,
            ),
            hoverColor: AppColors.grey6,
          ),
        ),
      ],
    );
  }
}
