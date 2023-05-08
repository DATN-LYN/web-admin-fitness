import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/slidable_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';

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
    return SlidableWrapper(
      handleDelete: () {},
      handleEdit: () {},
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Tag(
                            text: inbox.isSender ? 'Sender' : 'Receiver',
                            color: inbox.isSender
                                ? AppColors.success
                                : AppColors.error,
                            fontSize: 12,
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        inbox.userId,
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
    );
  }
}
