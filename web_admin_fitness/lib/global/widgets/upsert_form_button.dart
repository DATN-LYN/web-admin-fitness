import 'package:flutter/material.dart';

class UpsertFormButton extends StatelessWidget {
  const UpsertFormButton({
    super.key,
    required this.onPressPositiveButton,
    required this.onPressNegativeButton,
    required this.positiveButtonText,
    required this.negativeButtonText,
  });

  final VoidCallback onPressPositiveButton;
  final VoidCallback onPressNegativeButton;
  final String positiveButtonText;
  final String negativeButtonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onPressNegativeButton,
              child: Text(negativeButtonText),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onPressPositiveButton,
              child: Text(positiveButtonText),
            ),
          ),
        ],
      ),
    );
  }
}
