import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

class UserItem extends StatelessWidget with ClientMixin {
  UserItem({
    super.key,
    required this.user,
    required this.handleDelete,
  });

  final GUser user;
  final VoidCallback handleDelete;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          const SizedBox(width: 4),
          SlidableAction(
            onPressed: (context) => handleDelete(),
            icon: Icons.delete_outline,
            label: i18n.button_Delete,
            spacing: 10,
            backgroundColor: AppColors.deleteButton,
            foregroundColor: AppColors.grey1,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 8),
          SlidableAction(
            onPressed: (context) {},
            icon: Icons.edit_outlined,
            label: i18n.button_Edit,
            spacing: 10,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.grey1,
            borderRadius: BorderRadius.circular(8),
          )
        ],
      ),
      child: ShadowWrapper(
        child: Row(
          children: [
            ShimmerImage(
              imageUrl: user.avatar ?? '-',
              width: 50,
              height: 50,
              borderRadius: BorderRadius.circular(100),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: user.fullName ?? '_',
                      children: [
                        TextSpan(
                          text: ' - ${user.age}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(user.email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
