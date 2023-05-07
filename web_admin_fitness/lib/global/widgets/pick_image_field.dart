import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';

import '../themes/app_colors.dart';

class PickImageField extends StatelessWidget {
  const PickImageField({
    super.key,
    this.errorText,
    required this.onPickImage,
    this.image,
    required this.initialData,
    required this.isCreateNew,
  });

  final String? errorText;
  final VoidCallback onPickImage;
  final XFile? image;
  final String? initialData;
  final bool isCreateNew;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return InputDecorator(
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 48),
        errorText: errorText,
        contentPadding: const EdgeInsets.all(16),
      ),
      child: GestureDetector(
        onTap: onPickImage,
        child: Text(
          !isCreateNew && image == null
              ? initialData ?? ''
              : image != null
                  ? image!.name
                  : i18n.upsertExercise_ImageHint,
          style: TextStyle(
            color: image != null || !isCreateNew
                ? AppColors.grey1
                : AppColors.grey4,
          ),
        ),
      ),
    );
  }
}
