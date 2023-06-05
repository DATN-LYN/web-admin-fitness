import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';

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

    return SfCircularChart(
      title: ChartTitle(text: i18n.home_UserAgesPieChart),
      legend: Legend(isVisible: true),
      series: [
        PieSeries<int, String>(
          dataSource: widget.ages.entries.map((e) => e.value).toList(),
          xValueMapper: (data, index) =>
              widget.ages.keys.elementAt(index).toString(),
          yValueMapper: (data, _) => data,
          dataLabelMapper: (data, _) =>
              '${(data * 100 / widget.ages.length).round()} %',
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
        ),
      ],
    );
  }
}
