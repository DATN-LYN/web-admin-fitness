import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/toast/multi_toast.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/genders_chart.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/home_overview.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/top_programs_widget.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/top_users_widget.dart';

import '../../../../global/gen/i18n.dart';
import '../../../../global/graphql/query/__generated__/query_get_users.req.gql.dart';
import 'widgets/ages_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ClientMixin {
  Map<int, int> ages = {};
  Map<GGENDER, int> genders = {};
  List<GUser> users = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUsers();
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

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const HomeOverview(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AgesChart(
                ages: ages,
                usersLength: users.length,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GendersChart(
                genders: genders,
                usersLength: users.length,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const TopUsersWidget(),
        const SizedBox(height: 32),
        const TopProgramsWidget(),
        const SizedBox(height: 20),
      ],
    );
  }
}
