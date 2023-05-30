import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';

part 'program_filter_data.freezed.dart';

@freezed
class ProgramFilterData with _$ProgramFilterData {
  const factory ProgramFilterData([
    String? keyword,
    @Default([]) List<double> bodyParts,
    @Default([]) List<double> levels,
    GCategory? category,
  ]) = _ProgramFilterData;
}
