
import 'package:flutter/material.dart';

class ToastItem {
  ToastItem({
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.leadingIcon,
  });

  final String title;
  final String subtitle;
  final Color iconColor;
  final IconData leadingIcon;

  @override
  int get hashCode => title.hashCode + subtitle.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! ToastItem) return false;
    final item = other;
    return title == item.title && subtitle == item.subtitle;
  }
}
