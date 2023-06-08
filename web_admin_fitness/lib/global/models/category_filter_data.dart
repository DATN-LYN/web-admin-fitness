import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_filter_data.freezed.dart';

@freezed
class CategoryFilterData with _$CategoryFilterData {
  const factory CategoryFilterData([
    String? keyword,
    DateTime? createdAt,
  ]) = _CategoryFilterData;
}
