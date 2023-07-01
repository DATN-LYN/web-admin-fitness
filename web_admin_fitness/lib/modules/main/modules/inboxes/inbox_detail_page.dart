import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/extensions/date_time_extension.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/widgets/label.dart';

import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/themes/app_colors.dart';
import '../../../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../../../global/widgets/tag.dart';

class InboxDetailPage extends StatelessWidget {
  const InboxDetailPage({
    super.key,
    required this.inbox,
  });

  final GInbox inbox;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: RightSheetAppBar(
        title: Text(i18n.inboxes_InboxDetail),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Label(i18n.inboxes_UserId),
          TextFormField(
            enabled: false,
            initialValue: inbox.userId,
          ),
          Label(i18n.upsertUser_FullName),
          TextFormField(
            enabled: false,
            initialValue: inbox.user?.fullName ?? '__',
          ),
          Label(i18n.login_Email),
          TextFormField(
            enabled: false,
            initialValue: inbox.user?.email ?? '__',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(i18n.inboxes_Message),
              Tag(
                color: inbox.isSender ? AppColors.success : AppColors.alert,
                text: inbox.isSender ? i18n.inboxes_User : i18n.inboxes_Bot,
              )
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            enabled: false,
            initialValue: inbox.message,
            maxLines: 30,
            minLines: 1,
          ),
          Label(i18n.inboxes_CreatedAt),
          TextFormField(
            enabled: false,
            initialValue: inbox.createdAt?.formatDateTime(i18n),
          ),
        ],
      ),
    );
  }
}
