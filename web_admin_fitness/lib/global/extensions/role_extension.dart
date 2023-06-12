import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';

import '../gen/i18n.dart';

extension RoleExtension on GROLE {
  String label(I18n i18n) {
    switch (this) {
      case GROLE.Admin:
        return i18n.role[0];
      case GROLE.User:
        return i18n.role[1];
      default:
        return i18n.role[0];
    }
  }
}
