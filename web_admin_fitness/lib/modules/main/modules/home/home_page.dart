import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/toast/multi_toast.dart';

import '../../../../global/graphql/query/__generated__/query_get_users.req.gql.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ClientMixin {
  Map<int, int> ages = {};

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
      final data = response.data!.getUsers.items!
          .map((e) => e.age?.toInt() ?? 0)
          .toList();

      if (mounted) {
        setState(() {
          ages = data.fold<Map<int, int>>({}, (map, element) {
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: 400,
          child: ShadowWrapper(
            child: _buildDefaultPieChart(),
          ),
        ),
      ],
    );
  }

  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: 'Age Users'),
      legend: Legend(isVisible: true),
      series: [
        PieSeries<int, String>(
          dataSource: ages.entries.map((e) => e.value).toList(),
          xValueMapper: (data, index) => ages.keys.elementAt(index).toString(),
          yValueMapper: (data, _) => data,
          // dataLabelMapper: (data, _) => data.toString(),
          startAngle: 90,
          endAngle: 90,
          strokeColor: AppColors.white,
          strokeWidth: 0.2,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
