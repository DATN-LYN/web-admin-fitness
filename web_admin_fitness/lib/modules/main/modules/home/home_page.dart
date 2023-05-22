import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/label.dart';
import 'package:web_admin_fitness/global/widgets/program/program_item_large.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/toast/multi_toast.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/home_overview.dart';

import '../../../../global/graphql/query/__generated__/query_get_users.req.gql.dart';
import '../users/widgets/user_item.dart';
import 'widgets/ages_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ClientMixin {
  Map<int, int> ages = {};
  List<GUser> users = [];
  List<GProgram> programs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUsers();
      getPrograms();
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

      if (mounted) {
        setState(() {
          ages = userAges.fold<Map<int, int>>({}, (map, element) {
            map[element] = (map[element] ?? 0) + 1;
            return map;
          });
        });

        // setState(() {
        //   ages = mapData.entries.map((e) => e.value).toList();
        // });
      }
    }
  }

  void getPrograms() async {
    var getProgramsReq = GGetProgramsReq(
      (b) => b
        ..requestId = '@getProgramsReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100
        ..vars.queryParams.orderBy = 'Program.view',
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
          programs = response.data!.getPrograms.items!.map((p0) => p0).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Expanded(
            //   child: ShadowWrapper(
            //     child: AgesChart(ages: ages),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Label('Top Users Program'),
                  ListView.builder(
                    itemCount: users.length > 10 ? 10 : users.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserItem(
                        user: user,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Label('Top Users Inbox'),
                  ListView.builder(
                    itemCount: users.length > 10 ? 10 : users.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserItem(
                        user: user,
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Label('Most Viewed Programs'),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 10,
            mainAxisExtent: 310,
          ),
          shrinkWrap: true,
          itemCount: programs.length > 10 ? 10 : programs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final program = programs[index];
            return ProgramItemLarge(
              program: program,
            );
          },
        ),
      ],
    );
  }
}
