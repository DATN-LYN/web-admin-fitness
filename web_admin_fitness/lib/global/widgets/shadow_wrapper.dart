import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class ShadowWrapper extends StatelessWidget {
  const ShadowWrapper({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
    this.secondaryBoxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? secondaryBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 6),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(12, 26, 75, 0.1),
            blurRadius: 1,
          ),
          secondaryBoxShadow ??
              const BoxShadow(
                color: Color.fromRGBO(20, 37, 63, 0.06),
                offset: Offset(0, 10),
                blurRadius: 16,
              ),
        ],
      ),
      child: child,
    );
  }
}
