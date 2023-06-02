import '../gen/i18n.dart';

enum ChartType {
  column('column'),
  bar('bar'),
  line('line'),
  stepline('stepline');

  final String value;
  const ChartType(this.value);

  String label(I18n i18n) {
    switch (this) {
      case column:
        return i18n.chart_ChartType[0];
      case bar:
        return i18n.chart_ChartType[1];
      case line:
        return i18n.chart_ChartType[2];
      case stepline:
        return i18n.chart_ChartType[3];
      default:
        return i18n.workoutLevel[0];
    }
  }
}
