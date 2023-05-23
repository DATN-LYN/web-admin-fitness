import 'package:flutter/material.dart';

import '../../../../global/models/nav_item.dart';
import '../../../../global/themes/app_colors.dart';

class MenuNavTile extends StatelessWidget {
  const MenuNavTile({
    Key? key,
    required this.item,
    required this.duration,
    required this.isExpand,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final NavItem item;
  final Duration duration;
  final bool isExpand;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(right: 4),
            height: 52,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 24),
                isSelected
                    ? Icon(item.selectedIcon, color: AppColors.grey1, size: 24)
                    : Icon(item.icon, color: AppColors.grey3, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: duration,
                    child: isExpand
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.grey1
                                    : AppColors.grey3,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
