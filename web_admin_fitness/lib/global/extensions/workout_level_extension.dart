import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';

import '../gen/i18n.dart';
import '../themes/app_colors.dart';

extension WorkoutLevelExtension on GWORKOUT_LEVEL {
  String label(I18n i18n) {
    switch (this) {
      case GWORKOUT_LEVEL.Beginner:
        return i18n.workoutLevel[0];
      case GWORKOUT_LEVEL.Intermediate:
        return i18n.workoutLevel[1];
      case GWORKOUT_LEVEL.Advanced:
        return i18n.workoutLevel[2];
      default:
        return i18n.workoutLevel[0];
    }
  }

  Color color() {
    switch (this) {
      case GWORKOUT_LEVEL.Beginner:
        return AppColors.success;
      case GWORKOUT_LEVEL.Intermediate:
        return AppColors.information;
      case GWORKOUT_LEVEL.Advanced:
        return AppColors.warning;
      default:
        return AppColors.warning;
    }
  }
}
