import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

class UserItemHome extends StatelessWidget with ClientMixin {
  UserItemHome({
    super.key,
    required this.user,
  });

  final GUser user;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return ShadowWrapper(
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
            child: Row(
              children: [
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
                const SizedBox(width: 10),
                Text(user.countProgram?.toInt().toString() ?? '_'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
