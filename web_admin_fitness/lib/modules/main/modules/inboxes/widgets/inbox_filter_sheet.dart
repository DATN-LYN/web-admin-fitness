import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/widgets/filter/filter_sheet_wrapper.dart';
import 'package:web_admin_fitness/modules/main/modules/inboxes/models/inbox_filter_data.dart';

import '../../../../../../../global/themes/app_colors.dart';

class InboxFilterSheet extends StatefulWidget {
  const InboxFilterSheet({
    super.key,
    required this.inboxFilterData,
  });

  final InboxFilterData inboxFilterData;

  @override
  State<InboxFilterSheet> createState() => _InboxFilterSheetState();
}

class _InboxFilterSheetState extends State<InboxFilterSheet> {
  late InboxFilterData filter = widget.inboxFilterData;

  void handleClearFilter() {
    setState(() {
      filter = const InboxFilterData();
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
        ...[true, false].map(
          (e) => CheckboxListTile(
            value: filter.senders.contains(e),
            title: Text(e ? i18n.inboxes_User : i18n.inboxes_Bot),
            onChanged: (value) {
              setState(
                () {
                  if (value == true) {
                    filter = filter.copyWith(senders: [...filter.senders, e]);
                  } else {
                    filter = filter.copyWith(
                      senders:
                          filter.senders.whereNot((item) => item == e).toList(),
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
