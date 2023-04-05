import 'package:flutter/material.dart';

import 'card_overview_widget.dart';

class PhoneCardOverview extends StatelessWidget {
  const PhoneCardOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: CardOverviewWidget(),
            ),
            Expanded(
              child: CardOverviewWidget(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: CardOverviewWidget(),
            ),
            Expanded(
              child: CardOverviewWidget(),
            ),
          ],
        ),
      ],
    );
  }
}
