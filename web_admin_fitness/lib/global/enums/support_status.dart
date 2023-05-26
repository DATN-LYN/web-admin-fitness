import 'package:flutter/material.dart';

import '../gen/i18n.dart';
import '../themes/app_colors.dart';

enum SupportStatus {
  waiting(1),
  solving(2),
  done(3);

  final double value;
  const SupportStatus(this.value);

  static SupportStatus getStatus(double status) {
    return SupportStatus.values
        .firstWhere((element) => element.value == status);
  }

  String label(I18n i18n) {
    switch (this) {
      case waiting:
        return 'i18n.workoutLevel[0];';
      case solving:
        return 'i18n.workoutLevel[1];';
      case done:
        return 'i18n.workoutLevel[2];';
      default:
        return 'i18n.workoutLevel[0];';
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
      default:
        return AppColors.warning;
    }
  }
}
