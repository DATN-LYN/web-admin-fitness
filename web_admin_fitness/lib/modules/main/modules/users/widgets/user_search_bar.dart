import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.req.gql.dart';
import 'package:web_admin_fitness/modules/main/modules/users/models/user_filter_data.dart';
import 'package:web_admin_fitness/modules/main/modules/users/widgets/user_filter_sheet.dart';

import '../../../../../../../../../../../global/gen/i18n.dart';
import '../../../../../../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../../../../../../global/widgets/filter/filter_text_field.dart';
import '../../../../../global/themes/app_colors.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({
    super.key,
    required this.onChanged,
    required this.request,
    required this.initialFilter,
    required this.searchField,
  });

  final ValueChanged<GGetUsersReq> onChanged;
  final GGetUsersReq request;
  final UserFilterData initialFilter;
  final String searchField;

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  late UserFilterData filter = widget.initialFilter;

  void handleFilter(UserFilterData filterData) {
    filter = filterData;
    final newFilters = widget.request.vars.queryParams.filters?.toList() ?? [];

    // filter by keyword
    newFilters.removeWhere((e) => e.field == widget.searchField);
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

    // filter by role
    newFilters.removeWhere((e) => e.field == 'User.userRole');
    if (filterData.roles.isNotEmpty) {
      newFilters.add(
        GFilterDto((b) => b
          ..field = 'User.userRole'
          ..operator = GFILTER_OPERATOR.Gin
          ..data = filterData.roles.map((e) => e).join(',')),
      );
    }

    // filter by active/inactive
    newFilters.removeWhere((e) => e.field == 'User.isActive');
    if (filterData.active.isNotEmpty) {
      newFilters.add(
        GFilterDto((b) => b
          ..field = 'User.isActive'
          ..operator = GFILTER_OPERATOR.Gin
          ..data = filterData.active.map((e) => e).join(',')),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FilterTextField(
            hintText: i18n.users_SearchHint,
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
                body: UserFilterSheet(userFilterData: filter),
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

              if (newFilter is UserFilterData) {
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
