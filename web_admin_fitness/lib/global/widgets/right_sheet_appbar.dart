import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class RightSheetAppBar extends AppBar {
  RightSheetAppBar({super.key, super.title})
      : super(
          centerTitle: false,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            height: 1.5,
          ),
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: context.popRoute,
                icon: const Icon(
                  Icons.close,
                  color: AppColors.grey5,
                ),
              );
            }),
            const SizedBox(width: 16),
          ],
        );
}
