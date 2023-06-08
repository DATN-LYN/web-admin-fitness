import 'package:flutter/material.dart';

import '../../../../../global/themes/app_colors.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    this.onTap,
    required this.title,
    this.subTitle,
    this.trailing,
    this.titleColor,
    this.backgroundColorIc,
  });

  final IconData icon;
  final Color? backgroundColorIc;
  final void Function()? onTap;
  final String title;
  final Color? titleColor;
  final String? subTitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: SizedBox.square(
        dimension: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Container(
            color: backgroundColorIc ?? AppColors.primary,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 20,
              color: AppColors.grey1,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: titleColor ?? AppColors.grey1,
        ),
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle ?? '',
              style: const TextStyle(
                color: AppColors.grey3,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios_sharp,
            size: 20,
            color: AppColors.grey1,
          ),
    );
  }
}
