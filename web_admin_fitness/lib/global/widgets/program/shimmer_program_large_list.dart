import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../shimmer_wrapper.dart';

class ShimmerProgramLargeList extends StatelessWidget {
  const ShimmerProgramLargeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.neutral20,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
      ),
    );
  }
}
