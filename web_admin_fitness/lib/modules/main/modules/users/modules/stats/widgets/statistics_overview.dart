import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_user_stats.data.gql.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/themes/app_colors.dart';

class StatisticsOverview extends StatelessWidget {
  const StatisticsOverview({
    this.data,
    super.key,
  });

  final List<GGetUserStatsData_getUserStats_items>? data;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final hasData = data != null && data?.isNotEmpty == true;
    final calo = hasData
        ? data!.map((e) => e.caloCount).reduce((a, b) => a! + b!).toString()
        : '0';
    final duration = hasData
        ? data!.map((e) => e.durationCount).reduce((a, b) => a! + b!).toString()
        : '0';
    final program = hasData
        ? data!.map((e) => e.programCount).reduce((a, b) => a! + b!).toString()
        : '0';

    return Row(
      children: [
        UserStatisticItem(
          title: calo,
          subtitle: i18n.common_Calo,
          icon: const Icon(
            Icons.feed_rounded,
            size: 30,
            color: AppColors.success,
          ),
          backgroundColor: AppColors.successSoft,
        ),
        UserStatisticItem(
          title: duration,
          subtitle: i18n.common_Minutes,
          icon: const Icon(
            Icons.timelapse,
            size: 30,
            color: AppColors.warning,
          ),
          backgroundColor: AppColors.warningSoft,
        ),
        UserStatisticItem(
          title: program,
          subtitle: i18n.main_Programs,
          icon: const Icon(
            Icons.feed_rounded,
            size: 30,
            color: AppColors.success,
          ),
          backgroundColor: AppColors.successSoft,
        ),
      ],
    );
  }
}

class UserStatisticItem extends StatelessWidget {
  const UserStatisticItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
  });

  final Icon icon;
  final String title;
  final String subtitle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.grey6.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 25),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
