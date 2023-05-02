import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'shadow_wrapper.dart';

class CardOverviewWidget extends StatelessWidget {
  const CardOverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowWrapper(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'dkaskdkajjhjhjghhggdkajsd',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                Text('12'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
