import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'shimmer_wrapper.dart';

class ShimmerExerciseItem extends StatelessWidget {
  const ShimmerExerciseItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey6),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              color: AppColors.neutral20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 15,
                    color: AppColors.neutral20,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 15,
                    color: AppColors.neutral20,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 15,
                    color: AppColors.neutral20,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 15,
                    color: AppColors.neutral20,
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.neutral20,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
