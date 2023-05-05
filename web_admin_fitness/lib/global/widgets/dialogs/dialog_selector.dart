import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';

import '../../gen/i18n.dart';
import '../../utils/debouncer.dart';
import '../bottom_sheet_selector/bottom_sheet_selector.dart';
import '../bottom_sheet_selector/selector_tile.dart';

class DialogSelector<T> extends StatefulWidget {
  const DialogSelector({
    Key? key,
    required this.initial,
    required this.options,
    this.hasMoreData = false,
    this.onSearch,
    this.onChanged,
    this.isMultiple = false,
    this.decoration,
    required this.response,
    this.tileBuilder,
  }) : super(key: key);

  final bool isMultiple;
  final bool hasMoreData;
  final List<Option<T>> initial;
  final List<Option<T>> options;
  final OperationResponse response;
  final void Function(String keyword)? onSearch;
  final void Function(List<Option<T>> options)? onChanged;
  final Widget Function(Option<T> item)? tileBuilder;
  final InputDecoration? decoration;

  @override
  State<DialogSelector<T>> createState() => _DialogSelectorState<T>();
}

class _DialogSelectorState<T> extends State<DialogSelector<T>> {
  final debouncer = Debouncer();
  late final List<Option<T>> selectedOptions = widget.initial;

  void handleTextChange(String value) {
    debouncer.run(() {
      widget.onSearch?.call(value);
    });
  }

  void handleItemTap(Option<T> option) {
    if (widget.isMultiple) {
      setState(() {
        if (selectedOptions.contains(option)) {
          selectedOptions.remove(option);
        } else {
          selectedOptions.add(option);
        }
      });
    } else {
      setState(() {
        selectedOptions
          ..clear()
          ..add(option);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final i18n = I18n.of(context)!;

    return AlertDialog(
      insetPadding: const EdgeInsets.all(30),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        width: min(media.size.width * 0.85, 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                onChanged: handleTextChange,
                decoration: widget.decoration,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  if (widget.response.graphqlErrors?.isNotEmpty ?? false)
                    // TODO: user error widget
                    Text(widget.response.graphqlErrors.toString())
                  else
                    ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount:
                          widget.options.length + (widget.hasMoreData ? 1 : 0),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == widget.options.length) {
                          return Container(
                            height: 64,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        }
                        final option = widget.options[index];
                        return SelectorTile(
                          isSelected: selectedOptions.contains(option),
                          onTap: () {
                            handleItemTap(option);
                          },
                          child: widget.tileBuilder == null
                              ? Container(
                                  height: 48,
                                  alignment: Alignment.centerLeft,
                                  child: Text(option.label),
                                )
                              : widget.tileBuilder!(option),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ),
                  if (widget.response.loading)
                    Container(
                      color: Colors.white12,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: AutoRouter.of(context).pop,
                      child: Text(i18n.button_Cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedOptions.isEmpty && !widget.isMultiple
                          ? null
                          : () {
                              widget.onChanged?.call(selectedOptions);

                              AutoRouter.of(context).pop();
                            },
                      child: Text(i18n.button_Ok),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
