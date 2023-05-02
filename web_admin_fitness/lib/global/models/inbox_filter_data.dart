import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_filter_data.freezed.dart';

@freezed
class InboxFilterData with _$InboxFilterData {
  const factory InboxFilterData([
    String? keyword,
    DateTime? createdAt,
  ]) = _InboxFilterData;
}
