import 'package:flutter/material.dart';

import '../gen/i18n.dart';
import '../themes/app_colors.dart';

enum SupportStatus {
  waiting(1),
  solving(2),
  done(3),
  cancelled(4);

  final double value;
  const SupportStatus(this.value);

  static SupportStatus getStatus(double status) {
    return SupportStatus.values
        .firstWhere((element) => element.value == status);
  }

  String label(I18n i18n) {
    switch (this) {
      case waiting:
        return i18n.support_SupportStatus[0];
      case solving:
        return i18n.support_SupportStatus[1];
      case done:
        return i18n.support_SupportStatus[2];
      case cancelled:
        return i18n.support_SupportStatus[3];
      default:
        return i18n.support_SupportStatus[0];
    }
  }

  Color color() {
    switch (this) {
      case waiting:
        return AppColors.warning;
      case solving:
        return AppColors.information;
      case done:
        return AppColors.success;
      case cancelled:
        return AppColors.grey1;
      default:
        return AppColors.warning;
    }
  }
}
