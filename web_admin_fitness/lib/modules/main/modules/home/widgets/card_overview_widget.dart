import 'package:flutter/material.dart';

import '../../../../../global/themes/app_colors.dart';
import '../../../../../global/widgets/shadow_wrapper.dart';

class CardOverviewWidget extends StatelessWidget {
  const CardOverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowWrapper(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.dangerous,
              color: AppColors.grey1,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('dkaskdkadkajsd'),
              SizedBox(height: 8),
              Text('12'),
            ],
          ),
        ],
      ),
    );
  }
}
