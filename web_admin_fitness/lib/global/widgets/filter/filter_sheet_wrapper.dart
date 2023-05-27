import 'package:flutter/material.dart';

import '../../gen/i18n.dart';
import '../../themes/app_colors.dart';

class FilterSheetWrapper extends StatelessWidget {
  const FilterSheetWrapper({
    Key? key,
    required this.onClearAll,
    required this.onApply,
    required this.children,
  }) : super(key: key);

  final VoidCallback onClearAll;
  final VoidCallback onApply;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    i18n.filter_Filter,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.grey5,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.grey5),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 8),
                ...children,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onClearAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey6,
                    ),
                    child: Text(i18n.button_Reset),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApply,
                    child: Text(i18n.button_Apply),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
