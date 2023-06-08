import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';

import '../gen/i18n.dart';
import '../themes/app_colors.dart';

extension SupportStatusExtension on GSUPPORT_STATUS {
  String label(I18n i18n) {
    switch (this) {
      case GSUPPORT_STATUS.Waiting:
        return i18n.support_SupportStatus[0];
      case GSUPPORT_STATUS.Solving:
        return i18n.support_SupportStatus[1];
      case GSUPPORT_STATUS.Done:
        return i18n.support_SupportStatus[2];
      case GSUPPORT_STATUS.Canceled:
        return i18n.support_SupportStatus[3];
      default:
        return i18n.support_SupportStatus[0];
    }
  }

  Color color() {
    switch (this) {
      case GSUPPORT_STATUS.Waiting:
        return AppColors.warning;
      case GSUPPORT_STATUS.Solving:
        return AppColors.information;
      case GSUPPORT_STATUS.Done:
        return AppColors.success;
      case GSUPPORT_STATUS.Canceled:
        return AppColors.grey1;
      default:
        return AppColors.warning;
    }
  }
}
