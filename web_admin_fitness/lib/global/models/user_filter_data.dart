import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_filter_data.freezed.dart';

@freezed
class UserFilterData with _$UserFilterData {
  const factory UserFilterData([
    String? keyword,
    DateTime? createdAt,
  ]) = _UserFilterData;
}
