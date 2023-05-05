import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';

import '../../gen/i18n.dart';
import '../../utils/debouncer.dart';
import 'selector_tile.dart';

class Option<T> {
  Option({
    required this.label,
    required this.value,
    required this.key,
  });

  final String label;
  final String key;
  final T value;

  @override
  int get hashCode => Object.hash(label, key);

  @override
  bool operator ==(Object other) {
    if (other is! Option) return false;
    return key == other.key;
  }
}

class BottomSheetSelector<T> extends StatefulWidget {
  const BottomSheetSelector({
    Key? key,
    required this.initial,
    required this.options,
    this.onSearch,
    this.onChanged,
    this.isMultiple = false,
    this.decoration,
    required this.response,
    this.tileBuilder,
    required this.hasMoreData,
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
  State<BottomSheetSelector<T>> createState() => _BottomSheetSelectorState<T>();
}

class _BottomSheetSelectorState<T> extends State<BottomSheetSelector<T>> {
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
    widget.onChanged?.call(selectedOptions);

    if (!widget.isMultiple) {
      AutoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final media = MediaQuery.of(context);
    return SizedBox(
      height: media.size.height / 5 * 3 + media.viewInsets.bottom,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 8),
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
                if (widget.response.hasErrors)
                  FitnessError(response: widget.response)
                else if (widget.response.loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (widget.options.isEmpty)
                  FitnessEmpty(
                    title: i18n.common_NotFound,
                    // image: Assets.images.emptySearch.image(width: 120),
                    message: i18n.common_NotFound,
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount:
                        widget.options.length + (widget.hasMoreData ? 1 : 0),
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
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
