import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';

class PickImageField extends StatelessWidget {
  const PickImageField({
    super.key,
    this.errorText,
    required this.onPickImage,
    this.image,
    required this.fieldValue,
    required this.textColor,
  });

  final String? errorText;
  final VoidCallback onPickImage;
  final XFile? image;
  final String fieldValue;
  final Color textColor;
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
          fieldValue,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
