import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';
import '../themes/app_colors.dart';

class FitnessEmpty extends StatelessWidget {
  const FitnessEmpty({
    super.key,
    this.message,
    this.showImage = true,
    this.title,
    this.onPressed,
    this.textButton,
  }) : assert(
          (onPressed != null && textButton != null) ||
              (onPressed == null && textButton == null),
        );

  final String? title;
  final String? textButton;
  final String? message;
  final bool showImage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showImage) Assets.images.emptyData.image(height: 150),
            const SizedBox(height: 24),
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '$title',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '$message',
                  style: const TextStyle(
                    color: AppColors.grey3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            if (onPressed != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    textButton.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
