import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../gen/i18n.dart';
import '../../models/toast_item.dart';
import '../../themes/app_colors.dart';
import 'toast_tile.dart';

void showSuccessToast(
  BuildContext context,
  String subtitle,
) {
  final i18n = I18n.of(context)!;
  _showToast(
    context,
    ToastItem(
      title: i18n.toast_Title_Success,
      subtitle: subtitle,
      iconColor: AppColors.success,
      leadingIcon: Icons.check_circle,
    ),
  );
}

void showErrorToast(
  BuildContext context,
  String? subtitle,
) {
  final i18n = I18n.of(context)!;
  _showToast(
    context,
    ToastItem(
      title: i18n.toast_Title_Error,
      subtitle: subtitle ?? i18n.toast_Subtitle_Error,
      iconColor: AppColors.error,
      leadingIcon: Icons.cancel,
    ),
  );
}

void showWarningToast(
  BuildContext context,
  String subtitle,
) {
  final i18n = I18n.of(context)!;
  _showToast(
    context,
    ToastItem(
      title: i18n.toast_Title_Warning,
      subtitle: subtitle,
      iconColor: AppColors.warning,
      leadingIcon: Icons.error,
    ),
  );
}

void _showToast(BuildContext context, ToastItem item) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  if (overlayState == null) return;
  final controller = MultiToastController.instance;
  if (controller.isMount) {
    controller.insertToast(item);
  } else {
    controller.isMount = true;
    final overlayEntry = OverlayEntry(
      builder: (_) => MultiToast(
        controller: controller,
      ),
    );
    overlayState.insert(overlayEntry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.insertToast(item);
    });
  }
}

class MultiToastController {
  factory MultiToastController._internal() {
    return MultiToastController(
      duration: const Duration(seconds: 5),
    );
  }
  MultiToastController({required this.duration});

  static final instance = MultiToastController._internal();

  bool isMount = false;

  final listKey = GlobalKey<AnimatedListState>();
  final List<ToastItem> items = [];
  final Duration duration;
  final insertDuration = const Duration(milliseconds: 200);
  final removeDuration = const Duration(milliseconds: 200);

  void insertToast(ToastItem item) {
    if (items.contains(item)) return;
    items.insert(0, item);
    listKey.currentState!.insertItem(0, duration: insertDuration);
    Future.delayed(duration, () {
      _removeToast(item);
    });
  }

  void _removeToast(ToastItem item) {
    final index = items.indexOf(item);
    if (index == -1) return;
    items.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => ToastTile(
        animation: animation,
        item: item,
        isRemoving: true,
      ),
      duration: removeDuration,
    );
  }
}

class MultiToast extends StatelessWidget {
  const MultiToast({
    super.key,
    required this.controller,
  });

  final MultiToastController controller;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);
    return Align(
      alignment: isDesktopView ? Alignment.topRight : Alignment.bottomRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85 > 400
            ? 500
            : MediaQuery.of(context).size.width,
        child: AnimatedList(
          padding: const EdgeInsets.all(12),
          key: controller.listKey,
          shrinkWrap: true,
          initialItemCount: controller.items.length,
          itemBuilder: (context, index, animation) {
            return ToastTile(
              animation: animation,
              item: controller.items[index],
              isRemoving: false,
              onRemove: controller._removeToast,
            );
          },
        ),
      ),
    );
  }
}
