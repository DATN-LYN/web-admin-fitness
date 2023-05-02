import '../gen/i18n.dart';

enum WorkoutBodyPart {
  upper(1),
  downer(2),
  abs(3),
  fullBody(4);

  final double value;
  const WorkoutBodyPart(this.value);

  static WorkoutBodyPart getBodyPart(double bodyPartNumber) {
    return WorkoutBodyPart.values
        .firstWhere((element) => element.value == bodyPartNumber);
  }

  String label(I18n i18n) {
    switch (this) {
      case upper:
        return i18n.workoutBodyPart[0];
      case downer:
        return i18n.workoutBodyPart[1];
      case abs:
        return i18n.workoutBodyPart[2];
      case fullBody:
        return i18n.workoutBodyPart[3];
      default:
        return i18n.workoutBodyPart[0];
    }
  }
}
