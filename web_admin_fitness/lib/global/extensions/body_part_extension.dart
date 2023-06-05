import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';

import '../gen/i18n.dart';

extension BodyPartExtension on GBODY_PART {
  String label(I18n i18n) {
    switch (this) {
      case GBODY_PART.Upper:
        return i18n.workoutBodyPart[0];
      case GBODY_PART.Downer:
        return i18n.workoutBodyPart[1];
      case GBODY_PART.ABS:
        return i18n.workoutBodyPart[2];
      case GBODY_PART.FullBody:
        return i18n.workoutBodyPart[3];
      default:
        return i18n.workoutBodyPart[0];
    }
  }
}
