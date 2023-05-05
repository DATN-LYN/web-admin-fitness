import 'package:flutter/material.dart';

import '../gen/i18n.dart';
import '../themes/app_colors.dart';

enum WorkoutLevel {
  beginner(1),
  intermediate(2),
  advanced(3);

  final double value;
  const WorkoutLevel(this.value);

  static WorkoutLevel getLevel(double levelNumber) {
    return WorkoutLevel.values
        .firstWhere((element) => element.value == levelNumber);
  }

  String label(I18n i18n) {
    switch (this) {
      case beginner:
        return i18n.workoutLevel[0];
      case intermediate:
        return i18n.workoutLevel[1];
      case advanced:
        return i18n.workoutLevel[2];
      default:
        return i18n.workoutLevel[0];
    }
  }

  Color color() {
    switch (this) {
      case beginner:
        return AppColors.success;
      case intermediate:
        return AppColors.information;
      case advanced:
        return AppColors.warning;
      default:
        return AppColors.warning;
    }
  }
}
