import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';

part 'user_filter_data.freezed.dart';

@freezed
class UserFilterData with _$UserFilterData {
  const factory UserFilterData([
    String? keyword,
    DateTime? createdAt,
    @Default([]) List<GROLE> roles,
  ]) = _UserFilterData;
}
