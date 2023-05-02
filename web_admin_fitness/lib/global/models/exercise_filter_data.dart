import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_filter_data.freezed.dart';

@freezed
class ExerciseFilterData with _$ExerciseFilterData {
  const factory ExerciseFilterData([
    String? keyword,
    DateTime? createdAt,
  ]) = _ExerciseFilterData;
}
