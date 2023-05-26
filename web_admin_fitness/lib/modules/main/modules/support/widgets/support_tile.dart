import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/enums/support_status.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/support_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';

import '../../../../../global/graphql/cache_handler/upsert_support_cache_handler.dart';
import '../../../../../global/graphql/mutation/__generated__/mutation_upsert_support.req.gql.dart';

class SupportTile extends StatelessWidget with ClientMixin {
  SupportTile({
    super.key,
    required this.support,
  });

  final GSupport support;

  @override
  Widget build(BuildContext context) {
    final status = SupportStatus.getStatus(support.status ?? 1);
    final i18n = I18n.of(context)!;

    void markRead() async {
      var formData = GUpsertSupportInputDto(
        (b) => b
          ..content = support.content
          ..id = support.id
          ..imgUrl = support.imgUrl
          ..isRead = true
          ..status = support.status
          ..userId = support.userId,
      );
      var request = GUpsertSupportReq(
        (b) => b
          ..vars.input.replace(formData)
          ..updateCacheHandlerKey = UpsertSupportCacheHandler.key
          ..updateCacheHandlerContext = {
            'upsertData': formData,
          },
      );

      await client.request(request).first;
    }

    return InkWell(
      onTap: () {
        markRead();
        context.pushRoute(SupportUpsertRoute(support: support));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: support.isRead == true
            ? Colors.white
            : AppColors.warningSoft.withOpacity(0.7),
        child: Row(
          children: [
            ShimmerImage(
              imageUrl: support.user?.avatar ?? '_',
              width: 70,
              height: 70,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    support.user?.email ?? '_',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    support.content ?? '_',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Tag(
              text: status.label(i18n),
              color: status.color(),
            )
          ],
        ),
      ),
    );
  }
}
