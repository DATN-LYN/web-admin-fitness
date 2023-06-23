import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../../../../global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import '../../../../../global/graphql/query/__generated__/query_get_top_users_inbox.req.gql.dart';
import '../../../../../global/graphql/query/__generated__/query_get_top_users_program.req.gql.dart';
import '../../../../../global/widgets/toast/multi_toast.dart';
import 'user_inboxes_dialog.dart';
import 'user_item_home.dart';
import 'user_programs_dialog.dart';

class TopUsersWidget extends StatefulWidget {
  const TopUsersWidget({super.key});

  @override
  State<TopUsersWidget> createState() => _TopUsersWidgetState();
}

class _TopUsersWidgetState extends State<TopUsersWidget> with ClientMixin {
  List<GUser> topUsersProgram = [];
  List<GUser> topUsersInbox = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTopUsersProgram();
      getTopUsersInbox();
    });
    super.initState();
  }

  void getTopUsersProgram() async {
    var getUsersReq = GGetTopUsersProgramReq(
      (b) => b
        ..requestId = '@getTopUsersProgramReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100,
    );

    final response = await client.request(getUsersReq).first;

    if (response.hasErrors) {
      if (mounted) {
        showErrorToast(
          context,
          response.graphqlErrors?.first.message,
        );
      }
    } else {
      if (mounted) {
        setState(() {
          topUsersProgram =
              response.data!.getTopUsersProgram.items!.map((p0) => p0).toList();
          topUsersProgram
              .sort((b, a) => a.countProgram!.compareTo(b.countProgram!));
        });
      }
    }
  }

  void getTopUsersInbox() async {
    var getUsersReq = GGetTopUsersInboxReq(
      (b) => b
        ..requestId = '@getTopUsersInboxReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100,
    );

    final response = await client.request(getUsersReq).first;

    if (response.hasErrors) {
      if (mounted) {
        showErrorToast(
          context,
          response.graphqlErrors?.first.message,
        );
      }
    } else {
      if (mounted) {
        setState(() {
          topUsersInbox =
              response.data!.getTopUsersInbox.items!.map((p0) => p0).toList();
          topUsersInbox.sort((b, a) => a.countInbox!.compareTo(b.countInbox!));
        });
      }
    }
  }

  void showDialogProgramsOfUser(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return UserProgramsDialog(userId: userId);
      },
    );
  }

  void showDialogInboxesOfUser(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return UserInboxesDialog(userId: userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.home_TopUsersProgram,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                itemCount:
                    topUsersProgram.length > 5 ? 5 : topUsersProgram.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = topUsersProgram[index];
                  return UserItemHome(
                    user: user,
                    userCount: user.countProgram?.toInt().toString() ?? '_',
                    onTap: () => showDialogProgramsOfUser(user.id),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.home_TopUsersInbox,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                itemCount: topUsersInbox.length > 5 ? 5 : topUsersInbox.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = topUsersInbox[index];
                  return UserItemHome(
                    user: user,
                    userCount: user.countInbox?.toInt().toString() ?? '_',
                    onTap: () => showDialogInboxesOfUser(user.id),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
