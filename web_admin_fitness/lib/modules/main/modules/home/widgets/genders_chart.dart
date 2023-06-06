import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_fitness/global/extensions/gender_extension.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';

import '../../../../../global/themes/app_colors.dart';

class GendersChart extends StatefulWidget {
  const GendersChart({
    super.key,
    required this.genders,
  });
  final Map<GGENDER, int> genders;

  @override
  State<GendersChart> createState() => _GendersChartState();
}

class _GendersChartState extends State<GendersChart> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return SfCircularChart(
      title: ChartTitle(text: i18n.home_UserGendersPieChart),
      legend: Legend(isVisible: true),
      series: [
        PieSeries<int, String>(
          dataSource: widget.genders.entries.map((e) => e.value).toList(),
          xValueMapper: (data, index) =>
              widget.genders.keys.elementAt(index).label(i18n),
          yValueMapper: (data, _) => data,
          dataLabelMapper: (data, _) =>
              '${(data * 100 / widget.genders.length).round()} %',
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
