import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_filter_data.freezed.dart';

@freezed
class ProgramFilterData with _$ProgramFilterData {
  const factory ProgramFilterData([
    String? keyword,
    @Default([]) List<double> bodyParts,
    @Default([]) List<double> levels,
  ]) = _ProgramFilterData;
}
