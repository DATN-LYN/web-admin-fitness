import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../themes/app_colors.dart';

class RadioBox extends StatelessWidget {
  const RadioBox({
    super.key,
    required this.onTap,
    required this.isChecked,
    required this.label,
  });

  final bool isChecked;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: isChecked ? AppColors.primary : AppColors.grey3,
                ),
              ),
              child: isChecked
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.grey1,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(label)
          ],
        ),
      ),
    );
  }
}
