import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'shadow_wrapper.dart';

class CardOverviewWidget extends StatelessWidget {
  const CardOverviewWidget({
    super.key,
    required this.title,
    required this.total,
    this.icon,
    this.backgroundColor,
  });

  final String title;
  final double total;
  final Widget? icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ShadowWrapper(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.primarySoft,
              borderRadius: BorderRadius.circular(100),
            ),
            child: icon ??
                const Icon(
                  Icons.category,
                  color: AppColors.grey1,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Text(total.toInt().toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
