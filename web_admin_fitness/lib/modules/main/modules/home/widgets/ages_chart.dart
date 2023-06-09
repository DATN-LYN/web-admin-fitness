import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_fitness/global/extensions/double_extension.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';

import '../../../../../global/themes/app_colors.dart';

class AgesChart extends StatefulWidget {
  const AgesChart({
    super.key,
    required this.ages,
  });
  final Map<int, int> ages;

  @override
  State<AgesChart> createState() => _AgesChartState();
}

class _AgesChartState extends State<AgesChart> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18n.home_UserAgesPieChart,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ShadowWrapper(
          margin: EdgeInsets.zero,
          child: SfCircularChart(
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              builder: (data, point, _, __, ___) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6,
                  ),
                  child: Text(
                    '${(point.y as double).toStringWithNoZero()} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
            series: [
              DoughnutSeries<int, String>(
                enableTooltip: true,
                dataSource: widget.ages.entries.map((e) => e.value).toList(),
                xValueMapper: (data, index) =>
                    widget.ages.keys.elementAt(index).toString(),
                yValueMapper: (data, _) => data,
                dataLabelMapper: (data, _) =>
                    '${(data * 100 / widget.ages.length).round()}%',
                startAngle: 90,
                endAngle: 90,
                strokeColor: AppColors.white,
                strokeWidth: 0.2,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                innerRadius: '65%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
