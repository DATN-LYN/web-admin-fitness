// import 'dart:math';

// import 'package:built_collection/built_collection.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:responsive_framework/responsive_wrapper.dart';
// import 'package:side_sheet/side_sheet.dart';

// import '../../../../../../global/gen/i18n.dart';
// import '../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
// import '../../../../../../global/graphql/query/__generated__/query_get_remotes.req.gql.dart';
// import '../../../../../../global/themes/app_colors.dart';
// import '../../../../../../global/utils/app_icons.dart';
// import '../../../../../../global/widgets/filter/filter_text_field.dart';
// import '../enums/remote_search_mode.dart';
// import '../models/remote_filter_data.dart';
// import 'remote_filter_sheet.dart';

// class SearchBar extends StatefulWidget {
//   const SearchBar({
//     super.key,
//     required this.onChanged,
//     required this.request,
//     required this.initialFilter,
//     this.title,
//   });

//   final ValueChanged<dynamic> onChanged;
//   final dynamic request;
//   final dynamic initialFilter;
//   final String? title;

//   @override
//   State<SearchBar> createState() => _SearchBarState();
// }

// class _SearchBarState extends State<SearchBar> {
//   late dynamic filter = widget.initialFilter;

//   void handleFilter(dynamic filterData) {
//     filter = filterData;
//     final newFilters = widget.request.vars.queryParams.filters?.toList() ?? [];

//     // filter by schedule mode
//     newFilters.removeWhere((e) => e.field == 'Remote.isSchedule');
//     if (filterData.isSchedule != null) {
//       newFilters.add(
//         // GFilterDto(
//         //   (b) => b
//         //     ..field = 'Remote.isSchedule'
//         //     ..operator = GQUERY_OPERATOR.eq
//         //     ..data = filterData.isSchedule.toString(),
//         // ),
//       );
//     }

//     // filter by startDate and endDate
//     newFilters.removeWhere((e) => e.field == 'Remote.startDate');
//     newFilters.removeWhere((e) => e.field == 'Remote.endDate');
//     if (filterData.rangeType != null &&
//         filterData.startDate != null &&
//         filterData.endDate != null) {
//       newFilters.addAll([
//         // GFilterDto(
//         //   (b) => b
//         //     ..field = 'Remote.startDate'
//         //     ..operator = GQUERY_OPERATOR.gte
//         //     ..data = filterData.startDate.toString(),
//         // ),
//         // GFilterDto(
//         //   (b) => b
//         //     ..field = 'Remote.endDate'
//         //     ..operator = GQUERY_OPERATOR.lte
//         //     ..data = filterData.endDate.toString(),
//         // )
//       ]);
//     }

//     // filter by keyword
//     newFilters.removeWhere((e) => e.field == widget.searchMode.key);
//     if (filterData.keyword?.isNotEmpty ?? false) {
//       newFilters.add(
//         GFilterDto(
//           (b) => b
//             ..field = widget.searchMode.key
//             ..operator = GQUERY_OPERATOR.unaccentLike
//             ..data = filterData.keyword,
//         ),
//       );
//     }

//     // filter by status
//     newFilters.removeWhere((e) => e.field == 'Remote.status');
//     if (filterData.status.isNotEmpty) {
//       newFilters.add(
//         GFilterDto((b) => b
//           ..field = 'Remote.status'
//           ..operator = GQUERY_OPERATOR.Gin
//           ..data = filterData.status.map((e) => e.name).join(',')),
//       );
//     }

//     widget.onChanged(widget.request.rebuild(
//       (b) => b
//         ..vars.queryParams.page = 1
//         ..vars.queryParams.filters = ListBuilder(newFilters)
//         ..updateResult = (previous, result) => result,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final i18n = I18n.of(context)!;

//     final responsive = ResponsiveWrapper.of(context);
//     final isDesktopView = responsive.isLargerThan(MOBILE);

//     return Row(
//       children: [
//         if (isDesktopView)
//           Expanded(
//             flex: 3,
//             child: Text(
//               widget.remoteTitle ?? i18n.remote_RequestList,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//         Expanded(
//           flex: 1,
//           child: FilterTextField(
//             hintText: i18n.remote_SearchAndFilter_Search,
//             onTextChange: (text) => handleFilter(
//               filter.copyWith(keyword: text),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Material(
//           borderRadius: BorderRadius.circular(12),
//           clipBehavior: Clip.hardEdge,
//           color: Theme.of(context).canvasColor,
//           child: IconButton(
//             onPressed: () async {
//               final newFilter = await SideSheet.right(
//                 body: RemoteFilterSheet(initialFilters: filter),
//                 context: context,
//                 width: min(
//                   MediaQuery.of(context).size.width * 0.8,
//                   400,
//                 ),
//               );

//               // * (Optional) show dialog on mobile
//               // await showDialog(
//               //   context: context,
//               //   builder: (context) => Padding(
//               //     padding: const EdgeInsets.all(16),
//               //     child: Material(
//               //       clipBehavior: Clip.hardEdge,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(12),
//               //       ),
//               //       child: RemoteFilterSheet(initialFilters: filter),
//               //     ),
//               //   ),
//               // )

//               if (newFilter is RemoteFilterData) {
//                 handleFilter(newFilter);
//               }
//             },
//             icon: const Icon(
//               AppIcons.filled_options_2,
//               color: AppColors.neutral03,
//               size: 16,
//             ),
//             hoverColor: AppColors.neutral09,
//           ),
//         ),
//       ],
//     );
//   }
// }
