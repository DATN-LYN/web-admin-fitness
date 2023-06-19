import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/extensions/role_extension.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/widgets/filter/filter_sheet_wrapper.dart';
import 'package:web_admin_fitness/modules/main/modules/users/models/user_filter_data.dart';

import '../../../../../../../global/themes/app_colors.dart';

class UserFilterSheet extends StatefulWidget {
  const UserFilterSheet({
    super.key,
    required this.userFilterData,
  });

  final UserFilterData userFilterData;

  @override
  State<UserFilterSheet> createState() => _UserFilterSheetState();
}

class _UserFilterSheetState extends State<UserFilterSheet> {
  late UserFilterData filter = widget.userFilterData;

  void handleClearFilter() {
    setState(() {
      filter = const UserFilterData();
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
            i18n.upsertUser_Role,
            style: titleStyle,
          ),
        ),
        const SizedBox(height: 10),
        ...GROLE.values.map(
          (e) => CheckboxListTile(
            value: filter.roles.contains(e),
            title: Text(e.label(i18n)),
            onChanged: (value) {
              setState(
                () {
                  if (value == true) {
                    filter = filter.copyWith(roles: [...filter.roles, e]);
                  } else {
                    filter = filter.copyWith(
                      roles:
                          filter.roles.whereNot((item) => item == e).toList(),
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
