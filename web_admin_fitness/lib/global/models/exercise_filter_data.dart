import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';

part 'exercise_filter_data.freezed.dart';

@freezed
class ExerciseFilterData with _$ExerciseFilterData {
  const factory ExerciseFilterData([
    String? keyword,
    DateTime? createdAt,
    GProgram? program,
  ]) = _ExerciseFilterData;
}
