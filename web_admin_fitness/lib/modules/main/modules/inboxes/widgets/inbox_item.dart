import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/slidable_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';

import '../../../../../../../global/routers/app_router.dart';

class InboxItem extends StatelessWidget {
  const InboxItem({
    super.key,
    required this.inbox,
    required this.handleDelete,
  });

  final GInbox inbox;
  final VoidCallback handleDelete;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return SlidableWrapper(
      handleDelete: handleDelete,
      handleEdit: () => context.pushRoute(
        InboxDetailRoute(inbox: inbox),
      ),
      isView: true,
      child: GestureDetector(
        onTap: () => context.pushRoute(InboxDetailRoute(inbox: inbox)),
        child: ShadowWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShimmerImage(
                    imageUrl: inbox.user?.avatar ?? '_',
                    width: 46,
                    height: 46,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inbox.user?.email ?? '_',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Tag(
                              text: inbox.isSender
                                  ? i18n.inboxes_User
                                  : i18n.inboxes_Bot,
                              color: inbox.isSender
                                  ? AppColors.success
                                  : AppColors.alert,
                              fontSize: 12,
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          inbox.user?.fullName ?? '_',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(color: AppColors.grey3),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 14),
              Text(inbox.message ?? '_'),
            ],
          ),
        ),
      ),
    );
  }
}
