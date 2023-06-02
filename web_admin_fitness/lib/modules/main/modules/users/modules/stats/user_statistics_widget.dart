import 'package:built_collection/built_collection.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_user_stats.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../../../../../global/enums/filter_range_type.dart';
import '../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../global/widgets/fitness_error.dart';
import '../../models/statistics_filter_data.dart';
import 'widgets/statistics_chart.dart';
import 'widgets/statistics_filter.dart';
import 'widgets/statistics_overview.dart';

class UserStatisticsWidget extends StatefulWidget {
  const UserStatisticsWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<UserStatisticsWidget> createState() => _UserStatisticsWidgetState();
}

class _UserStatisticsWidgetState extends State<UserStatisticsWidget>
    with ClientMixin {
  var filterData = StatisticsFilterData(
    rangeType: FilterRangeType.weekly,
    month: Jiffy().month,
    year: Jiffy().year,
  );
  var key = GlobalKey();

  late var getMyStatsReq = GGetUserStatsReq(
    (b) => b
      ..requestId = '@getUserStatsRequestId'
      ..vars.queryParams.limit = 200
      ..vars.queryParams.page = 1
      ..vars.userId = widget.userId
      ..vars.queryParams.filters = ListBuilder(
        [
          GFilterDto(
            (b) => b
              ..data = filterData.rangeType!.startDate().toString()
              ..field = 'UserStatistics.updatedAt'
              ..operator = GFILTER_OPERATOR.gt,
          ),
          GFilterDto(
            (b) => b
              ..data = filterData.rangeType!.endDate().toString()
              ..field = 'UserStatistics.updatedAt'
              ..operator = GFILTER_OPERATOR.lt,
          ),
        ],
      ),
  );

  void handleFilterChange(
    GGetUserStatsReq newReq,
    StatisticsFilterData filter,
  ) {
    setState(() {
      key = GlobalKey();
      filterData = filter;
      getMyStatsReq = getMyStatsReq.rebuild((b) => b
        ..vars.queryParams.filters =
            newReq.vars.queryParams.filters?.toBuilder());
      client.requestController.add(getMyStatsReq);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Operation(
      client: client,
      operationRequest: getMyStatsReq,
      builder: (context, response, error) {
        if (response?.loading == true) {
          return const SizedBox();
        }

        if (response?.hasErrors == true) {
          return FitnessError(response: response);
        }

        final data = response?.data;
        final stats = data!.getUserStats.items!.toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatisticsFilter(
              filter: filterData,
              request: getMyStatsReq,
              onChanged: (getMyStatsReq, selectedFilter) =>
                  handleFilterChange(getMyStatsReq, selectedFilter),
            ),
            StatisticsOverview(
              data: stats,
            ),
            const SizedBox(height: 16),
            StatisticsChart(
              key: key,
              data: stats,
              filter: filterData,
            ),
          ],
        );
      },
    );
  }
}
