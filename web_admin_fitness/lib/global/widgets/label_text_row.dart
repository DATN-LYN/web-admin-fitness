import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class LabelTextRow extends StatelessWidget {
  const LabelTextRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String? value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      WidgetSpan(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 15,
                color: AppColors.grey4,
              ),
            const SizedBox(width: 8),
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                value ?? '_',
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
