import 'package:auto_route/auto_route.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_user.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_inbox_item.dart';
import 'package:web_admin_fitness/modules/main/modules/inboxes/widgets/inbox_item.dart';

import '../../../../../global/gen/i18n.dart';

class UserInboxesDialog extends StatefulWidget {
  const UserInboxesDialog({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<UserInboxesDialog> createState() => _UserInboxesDialogState();
}

class _UserInboxesDialogState extends State<UserInboxesDialog>
    with ClientMixin {
  late var req = GGetUserReq(
    (b) => b.vars.userId = widget.userId,
  );
  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 700,
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Operation(
              client: client,
              operationRequest: req,
              builder: (context, response, error) {
                if (response?.hasErrors == true) {
                  return FitnessError(response: response);
                }

                if (response?.loading == true) {
                  return ListView.separated(
                    itemCount: 3,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return const ShimmerInboxItem();
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                  );
                }

                final data = response?.data?.getUser;
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      '${i18n.home_InboxesOf} ${data?.fullName ?? '_'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: data?.userPrograms?.isNotEmpty == true
                          ? ListView.separated(
                              itemCount: data!.inboxes?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = data.inboxes![index];
                                return InboxItem(inbox: item);
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 16),
                            )
                          : FitnessEmpty(
                              title: i18n.common_NotFound,
                            ),
                    )
                  ],
                );
              },
            ),
            IconButton(
              onPressed: context.popRoute,
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ),
    );
  }
}
