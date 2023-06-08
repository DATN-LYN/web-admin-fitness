import 'package:built_value/serializer.dart';

class DateSerializer implements PrimitiveSerializer<DateTime> {
  @override
  DateTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    if (serialized is int) {
      return DateTime.fromMillisecondsSinceEpoch(serialized).toLocal();
    } else {
      return DateTime.parse(serialized.toString()).toLocal();
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DateTime date, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      date.toUtc().millisecondsSinceEpoch;

  @override
  Iterable<Type> get types => [DateTime];

  @override
  String get wireName => 'DateTime';
}
