import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../../global/widgets/card_overview_widget.dart';

class UsersOverview extends StatelessWidget {
  const UsersOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: responsive.adap(2, 4),
      crossAxisSpacing: responsive.adap(12, 24),
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
      padding: const EdgeInsets.all(16),
      gridDelegate: gridDelegate,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
