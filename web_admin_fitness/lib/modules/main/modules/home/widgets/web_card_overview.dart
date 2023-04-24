import 'package:flutter/material.dart';

import 'card_overview_widget.dart';

class WebCardOverview extends StatelessWidget {
  const WebCardOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          child: CardOverviewWidget(),
        ),
        Expanded(
          child: CardOverviewWidget(),
        ),
        Expanded(
          child: CardOverviewWidget(),
        ),
        Expanded(
          child: CardOverviewWidget(),
        ),
      ],
    );
  }
}
