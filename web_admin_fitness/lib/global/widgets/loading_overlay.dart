import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.loading,
  });

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          const SizedBox.expand(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(
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
