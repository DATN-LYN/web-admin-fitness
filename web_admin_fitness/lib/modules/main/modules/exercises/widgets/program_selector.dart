import 'package:built_collection/built_collection.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../../../../global/utils/constants.dart';
import '../../../../../../../global/widgets/bottom_sheet_selector/bottom_sheet_selector.dart';
import '../../../../../../../global/widgets/dialogs/dialog_selector.dart';
import '../../../../../../../global/widgets/infinity_list.dart';

extension GProgramExt on GProgram {
  Option<GProgram> get option => Option(
        label: name ?? '_',
        key: id!,
        value: this,
      );
}

class ProgramSelector extends StatefulWidget {
  const ProgramSelector({
    super.key,
    required this.initial,
    this.onChanged,
    this.errorText,
    this.suffixIcon,
  });

  final List<GProgram> initial;
  final void Function(List<Option<GProgram>> option)? onChanged;
  final String? errorText;
  final Widget? suffixIcon;

  @override
  State<ProgramSelector> createState() => _ProgramSelectorState();
}

class _ProgramSelectorState extends State<ProgramSelector> with ClientMixin {
  late List<Option<GProgram>> selectedOptions =
      widget.initial.map((e) => e.option).toList();

  void showBottomSheet() {
    var req = GGetProgramsReq(
      (b) => b
        ..requestId = '@getProgramsRequestId'
        ..vars.queryParams.page = 1
        ..vars.queryParams.limit = Constants.defaultLimit,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => InfinityList(
        client: client,
        request: req,
        refreshRequest: () {
          req = req.rebuild(
            (b) => b
              ..vars.queryParams.page = 1
              ..updateResult = ((previous, result) => result),
          );
          return req;
        },
        loadMoreRequest: (response) {
          final data = response!.data!.getPrograms;
          final hasMoreData = data.meta!.currentPage! < data.meta!.totalPages!;
          if (hasMoreData) {
            req = req.rebuild(
              (b) => b
                ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
                ..updateResult = (previous, result) {
                  return previous?.rebuild(
                        (b) => b.getPrograms
                          ..meta = (result?.getPrograms.meta ??
                                  previous.getPrograms.meta)!
                              .toBuilder()
                          ..items.addAll(result?.getPrograms.items ?? []),
                      ) ??
                      result;
                },
            );
            return req;
          }
          return null;
        },
        builder: (context, response, error) {
          final i18n = I18n.of(context)!;
          final data = response?.data?.getPrograms;
          final hasMoreData = data != null
              ? data.meta!.currentPage! < data.meta!.totalPages!
              : false;
          return DialogSelector<GProgram>(
            initial: selectedOptions,
            isMultiple: false,
            decoration: InputDecoration(
              hintText: i18n.upsertProgram_NameHint,
            ),
            response: response as OperationResponse,
            hasMoreData: hasMoreData,
            tileBuilder: (option) => ProgramSelectorTile(program: option.value),
            options: response?.data?.getPrograms.items!
                    .map((p0) => p0.option)
                    .toList() ??
                [],
            onChanged: (options) {
              setState(() {
                selectedOptions = options;
              });
              widget.onChanged?.call(options);
            },
            onSearch: (keyword) async {
              req = req.rebuild(
                (p0) => p0
                  ..vars.queryParams.page = 1
                  ..updateResult = ((previous, result) => result)
                  ..vars.queryParams.filters = ListBuilder([
                    GFilterDto(
                      (b) => b
                        ..field = 'Program.name'
                        ..data = keyword
                        ..operator = GFILTER_OPERATOR.like,
                    ),
                  ]),
              );
              client.requestController.add(req);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return InputDecorator(
      decoration: InputDecoration(
        errorText: widget.errorText,
        contentPadding: EdgeInsets.all(selectedOptions.isEmpty ? 14 : 8),
        constraints: const BoxConstraints(minHeight: 48),
        suffixIcon: widget.suffixIcon,
      ),
      child: GestureDetector(
        onTap: showBottomSheet,
        child: selectedOptions.isEmpty
            ? Text(
                i18n.upsertExercise_ProgramHint,
                style:
                    Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                          height: 1.35,
                        ),
              )
            : Row(
                children: [
                  ShimmerImage(
                    width: 30,
                    height: 30,
                    imageUrl: selectedOptions.first.value.imgUrl ?? '_',
                  ),
                  const SizedBox(width: 12),
                  Text(
                    selectedOptions.first.label,
                    style: const TextStyle(height: 1.35),
                  ),
                ],
              ),
      ),
    );
  }
}

class ProgramSelectorTile extends StatelessWidget {
  const ProgramSelectorTile({
    super.key,
    required this.program,
  });

  final GProgram program;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          ShimmerImage(
            imageUrl: program.imgUrl ?? '_',
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(100),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.name ?? '_',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  program.id ?? '_',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
