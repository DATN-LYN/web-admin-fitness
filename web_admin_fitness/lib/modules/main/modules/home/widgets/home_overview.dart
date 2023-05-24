import 'package:auto_route/auto_route.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_home_summary.req.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../../global/widgets/card_overview_widget.dart';
import '../../../../../global/widgets/shimmer_card_overview.dart';

class HomeOverview extends StatefulWidget {
  const HomeOverview({
    super.key,
  });

  @override
  State<HomeOverview> createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> with ClientMixin {
  var request = GGetHomeOverViewReq();

  @override
  void initState() {
    final controller = AutoRouter.of(context).childControllers.first;
    controller.addListener(() {
      if (controller.current.name == HomeRoute.name) {
        if (mounted) {
          setState(() {
            request = request.rebuild(
              (b) => b..updateResult = ((previous, result) => result),
            );
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final responsive = ResponsiveWrapper.of(context);
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: responsive.adap(2, 4),
      crossAxisSpacing: responsive.adap(12, 24),
      mainAxisSpacing: 10,
      mainAxisExtent: 80,
    );

    return Operation(
      client: client,
      operationRequest: request,
      builder: (context, response, error) {
        if (response?.hasErrors ?? false) {
          return FitnessError(response: response!);
        }

        if (response?.loading ?? true) {
          return GridView.builder(
            padding: const EdgeInsets.all(0),
            gridDelegate: gridDelegate,
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return const ShimmerCardOverview();
            },
          );
        }

        final myRemoteSummary = response?.data?.getHomeOverView;

        final items = [
          CardOverviewWidget(
            title: i18n.main_Categories,
            total: myRemoteSummary?.categoryCnt ?? 0,
            icon: Icons.category_outlined,
          ),
          CardOverviewWidget(
            title: i18n.main_Programs,
            total: myRemoteSummary?.programCnt ?? 0,
            icon: Icons.view_list_outlined,
          ),
          CardOverviewWidget(
            title: i18n.main_Exercises,
            total: myRemoteSummary?.exerciseCnt ?? 0,
            icon: Icons.video_collection_outlined,
          ),
          CardOverviewWidget(
            title: i18n.main_Users,
            total: myRemoteSummary?.userCnt ?? 0,
            icon: Icons.account_circle_outlined,
          ),
        ];

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: gridDelegate,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        );
      },
    );
  }
}
