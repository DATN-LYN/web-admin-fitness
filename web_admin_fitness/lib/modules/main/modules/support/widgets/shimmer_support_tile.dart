import 'package:flutter/material.dart';

import '../../../../../global/themes/app_colors.dart';
import '../../../../../global/widgets/shimmer_wrapper.dart';

class ShimmerSupportTile extends StatelessWidget {
  const ShimmerSupportTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.neutral20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.neutral20,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 200,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.neutral20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.neutral20,
            ),
          )
        ],
      ),
    );
  }
}
