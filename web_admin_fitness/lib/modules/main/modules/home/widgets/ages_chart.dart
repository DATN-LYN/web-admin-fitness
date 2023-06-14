import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';

import '../../../../../global/themes/app_colors.dart';

class AgesChart extends StatefulWidget {
  const AgesChart({
    super.key,
    required this.ages,
    required this.usersLength,
  });
  final Map<int, int> ages;
  final int usersLength;

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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ShadowWrapper(
          margin: EdgeInsets.zero,
          child: SfCircularChart(
            legend: Legend(isVisible: true),
            series: [
              DoughnutSeries<int, String>(
                dataSource: widget.ages.entries.map((e) => e.value).toList(),
                xValueMapper: (data, index) =>
                    widget.ages.keys.elementAt(index).toString(),
                yValueMapper: (data, _) => data,
                dataLabelMapper: (data, _) =>
                    '${(data * 100 / widget.usersLength).round()}%',
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
