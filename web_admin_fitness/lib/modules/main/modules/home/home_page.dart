import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_top_users_inbox.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_top_users_program.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/label.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/toast/multi_toast.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/genders_chart.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/home_overview.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/user_item_home.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/user_programs_dialog.dart';

import '../../../../global/gen/i18n.dart';
import '../../../../global/graphql/query/__generated__/query_get_users.req.gql.dart';
import '../../../../global/widgets/program/program_item_large.dart';
import 'widgets/ages_chart.dart';
import 'widgets/user_inboxes_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ClientMixin {
  Map<int, int> ages = {};
  Map<GGENDER, int> genders = {};
  List<GUser> users = [];
  List<GUser> topUsersProgram = [];
  List<GUser> topUsersInbox = [];
  List<GProgram> mostViewedPrograms = [];
  List<GProgram> newestPrograms = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUsers();
      getMostViewedPrograms();
      getNewestPrograms();
      getTopUsersProgram();
      getTopUsersInbox();
    });
    super.initState();
  }

  void getUsers() async {
    var getUsersReq = GGetUsersReq(
      (b) => b
        ..requestId = '@getUsersReq'
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
      users = response.data!.getUsers.items!.map((p0) => p0).toList();
      final userAges = users.map((e) => e.age?.toInt() ?? 0).toList();
      final userGenders = users.map((e) => e.gender ?? GGENDER.Male).toList();

      if (mounted) {
        setState(() {
          ages = userAges.fold<Map<int, int>>({}, (map, element) {
            map[element] = (map[element] ?? 0) + 1;
            return map;
          });
          genders = userGenders.fold<Map<GGENDER, int>>({}, (map, element) {
            map[element] = (map[element] ?? 0) + 1;
            return map;
          });
        });
      }
    }
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
        });
      }
    }
  }

  void getMostViewedPrograms() async {
    var getProgramsReq = GGetProgramsReq(
      (b) => b
        ..requestId = '@getMostViewedProgramsReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100
        ..vars.queryParams.orderBy = 'Program.view:DESC',
    );

    final response = await client.request(getProgramsReq).first;

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
          mostViewedPrograms =
              response.data!.getPrograms.items!.map((p0) => p0).toList();
        });
      }
    }
  }

  void getNewestPrograms() async {
    var getProgramsReq = GGetProgramsReq(
      (b) => b
        ..requestId = '@getNewestProgramsReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100
        ..vars.queryParams.orderBy = 'Program.createdAt:DESC',
    );

    final response = await client.request(getProgramsReq).first;

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
          newestPrograms =
              response.data!.getPrograms.items!.map((p0) => p0).toList();
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
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return ListView(
      children: [
        const HomeOverview(),
        Row(
          children: [
            Expanded(
              child: ShadowWrapper(
                child: AgesChart(ages: ages),
              ),
            ),
            Expanded(
              child: ShadowWrapper(
                child: GendersChart(genders: genders),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Label(i18n.home_TopUsersProgram),
                  ListView.separated(
                    itemCount: topUsersProgram.length > 10
                        ? 10
                        : topUsersProgram.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = users[index];
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
            Expanded(
              child: Column(
                children: [
                  Label(i18n.home_TopUsersInbox),
                  ListView.separated(
                    itemCount:
                        topUsersInbox.length > 10 ? 10 : topUsersInbox.length,
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
        ),
        const SizedBox(height: 20),
        Text(
          i18n.home_MostViewedPrograms,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktopView ? 5 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            mainAxisExtent: 310,
          ),
          shrinkWrap: true,
          itemCount:
              mostViewedPrograms.length > 10 ? 10 : mostViewedPrograms.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final program = mostViewedPrograms[index];
            return ProgramItemLarge(
              program: program,
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          i18n.home_NewestPrograms,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktopView ? 5 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            mainAxisExtent: 310,
          ),
          shrinkWrap: true,
          itemCount: newestPrograms.length > 10 ? 10 : newestPrograms.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final program = newestPrograms[index];
            return ProgramItemLarge(
              program: program,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
