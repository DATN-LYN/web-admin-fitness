import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../themes/app_colors.dart';

class IndicatorLoading extends StatelessWidget {
  const IndicatorLoading({
    super.key,
    this.size = 30,
    this.color = AppColors.primary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(size: size, color: color);
  }
}
