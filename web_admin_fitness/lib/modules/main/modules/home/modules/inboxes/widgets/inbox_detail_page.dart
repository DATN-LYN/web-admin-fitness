import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/widgets/label.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/themes/app_colors.dart';
import '../../../../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../../../../global/widgets/tag.dart';

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
            initialValue: inbox.userId,
          ),
          Label(i18n.upsertUser_FullName),
          TextFormField(
            initialValue: inbox.user?.fullName,
          ),
          Label(i18n.login_Email),
          TextFormField(
            initialValue: inbox.user?.email,
          ),
          Row(
            children: [
              Text(i18n.inboxes_Message),
              const SizedBox(width: 12),
              Tag(
                color: inbox.isSender ? AppColors.success : AppColors.alert,
                text: inbox.isSender ? i18n.inboxes_User : i18n.inboxes_Bot,
              )
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: inbox.message,
            maxLines: 30,
            minLines: 1,
          ),
          Label(i18n.inboxes_CreatedAt),
          TextFormField(
            initialValue: inbox.createdAt?.toIso8601String(),
          ),
        ],
      ),
    );
  }
}
