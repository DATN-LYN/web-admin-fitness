import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../global/widgets/card_overview_widget.dart';

class ProgramsOverview extends StatelessWidget {
  const ProgramsOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: responsive.adap(2, 4),
      mainAxisSpacing: 10,
      mainAxisExtent: 80,
    );
    final items = [
      const CardOverviewWidget(),
      const CardOverviewWidget(),
      const CardOverviewWidget(),
      const CardOverviewWidget(),
    ];
    return GridView.builder(
      gridDelegate: gridDelegate,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
