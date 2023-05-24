import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_wrapper.dart';

import '../themes/app_colors.dart';

class ShimmerCardOverview extends StatelessWidget {
  const ShimmerCardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
