import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'shimmer_wrapper.dart';

class ShimmerImage extends StatelessWidget {
  const ShimmerImage({
    super.key,
    required this.imageUrl,
    this.iconErrorSize = 20,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
    this.borderImage,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final double iconErrorSize;
  final BoxFit fit;
  final Widget? errorWidget;
  final double? borderImage;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(borderImage ?? 0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ShimmerWrapper(
          child: Container(
            height: width,
            width: height,
            color: AppColors.background,
          ),
        ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Icon(
              Icons.error,
              size: iconErrorSize,
            ),
      ),
    );
  }
}
