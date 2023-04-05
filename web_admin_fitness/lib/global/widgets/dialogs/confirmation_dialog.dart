import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../gen/i18n.dart';
import '../../themes/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.image,
    this.titleText,
    this.contentText,
    this.title,
    this.content,
    this.positiveButtonText,
    this.onTapPositiveButton,
    this.negativeButtonText,
    this.onTapNegativeButton,
  });

  final Widget? image;
  final String? titleText;
  final String? contentText;
  final Widget? title;
  final Widget? content;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onTapPositiveButton;
  final VoidCallback? onTapNegativeButton;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: SizedBox.square(
                    dimension: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Container(
                        color: AppColors.primary,
                        alignment: Alignment.center,
                        child:
                            image ?? const Icon(Icons.question_answer_outlined),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (titleText != null)
                  Text(
                    titleText!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  )
                else if (title != null)
                  title!,
                if (content != null)
                  content!
                else if (contentText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 32),
                    child: Text(
                      contentText!,
                      style: const TextStyle(color: AppColors.grey2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onTapNegativeButton ?? context.popRoute,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grey4.withOpacity(0.6),
                        ),
                        child: Text(negativeButtonText ?? i18n.button_Cancel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onTapPositiveButton ?? context.popRoute,
                        child: Text(positiveButtonText ?? i18n.button_Ok),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: context.popRoute,
              icon: const Icon(
                Icons.close,
                color: AppColors.grey2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
