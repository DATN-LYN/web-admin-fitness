import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../themes/app_colors.dart';
import 'indicator_loading.dart';

class ElevatedButtonOpacity extends StatelessWidget {
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isOutline;
  final double radius;
  final double height;
  final double? width;
  final bool loading;
  final String label;
  final Color color;
  final Widget? leftIcon;
  final double fontSize;

  const ElevatedButtonOpacity({
    super.key,
    required this.label,
    this.loading = false,
    this.isOutline = false,
    this.onTap,
    this.margin,
    this.padding,
    this.radius = 8,
    this.height = 40,
    this.fontSize = 14,
    this.width,
    this.leftIcon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: onTap != null
              ? (isOutline ? Colors.transparent : color)
              : AppColors.neutral20,
          border: Border.all(
            width: isOutline ? 1 / 2 : 0,
            color: isOutline ? AppColors.grey1 : Colors.transparent,
          ),
        ),
        child: Center(
          child: loading
              ? const IndicatorLoading()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leftIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: leftIcon,
                      ),
                    Text(
                      label,
                      style: TextStyle(
                        height: 0,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
