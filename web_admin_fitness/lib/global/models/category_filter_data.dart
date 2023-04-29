import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_filter_data.freezed.dart';

@freezed
class CategoryFilterData with _$CategoryFilterData {
  const factory CategoryFilterData([
    String? keyword,
    // FilterRangeType? rangeType,
    bool? isSchedule,
    DateTime? startDate,
    DateTime? endDate,
    // @Default([]) List<GREMOTE_STATUS> status,
  ]) = _CategoryFilterData;
}
