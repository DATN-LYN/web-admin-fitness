import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.loading,
    this.isDark = true,
  });

  final Widget child;
  final bool loading;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          SizedBox.expand(
            child: ColoredBox(
              color: isDark ? Colors.black26 : Colors.white38,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          )
      ],
    );
  }
}
