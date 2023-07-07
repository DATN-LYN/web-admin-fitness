import 'dart:math';

import 'package:adaptive_selector/adaptive_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../graphql/fragment/__generated__/meta_fragment.data.gql.dart';

class TablePager extends StatefulWidget {
  const TablePager({
    Key? key,
    required this.onPageChange,
    required this.onPageLimitChange,
    this.showPageInput = false,
    this.pageMeta,
  }) : super(key: key);

  final ValueChanged<int> onPageChange;
  final ValueChanged<int> onPageLimitChange;
  final GMeta? pageMeta;
  final bool showPageInput;

  @override
  State<TablePager> createState() => _TablePagerState();
}

class _TablePagerState extends State<TablePager> {
  final scrollController = ScrollController();
  final pageLimitController = TextEditingController();
  final pageNumberController = TextEditingController();
  late int currentPage = widget.pageMeta?.currentPage?.toInt() ?? 1;
  late int totalPage = widget.pageMeta?.totalPages?.toInt() ?? 1;

  final pageLimitOptions = [15, 20, 25, 30]
      .map((e) => AdaptiveSelectorOption(label: e.toString(), value: e))
      .toList();

  @override
  void didUpdateWidget(covariant TablePager oldWidget) {
    if (widget.pageMeta?.totalPages != null) {
      totalPage = widget.pageMeta!.totalPages!.toInt();
      currentPage = widget.pageMeta!.currentPage!.toInt();
    }
    super.didUpdateWidget(oldWidget);
  }

  void changePage(int page) {
    setState(() => currentPage = page);
    widget.onPageChange(page);
  }

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: AdaptiveSelector(
            type: SelectorType.menu,
            allowClear: false,
            initial: [pageLimitOptions.first],
            options: pageLimitOptions,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 12, right: 0, top: 12),
              border: textFieldBorder,
              errorBorder: textFieldBorder,
              enabledBorder: textFieldBorder,
              focusedBorder: textFieldBorder,
              disabledBorder: textFieldBorder,
              focusedErrorBorder: textFieldBorder,
            ),
            onChanged: (option) {
              if (option.isEmpty) return;
              widget.onPageLimitChange(option.first.value);
            },
          ),
        ),
        const SizedBox(width: 18),
        renderItemDes(),
        const SizedBox(width: 24),
        PagerButton(
          onTap: currentPage > 1 ? () => changePage(1) : null,
          child: const Icon(
            Icons.first_page_sharp,
            color: Colors.grey,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        PagerButton(
          onTap: currentPage - 1 > 0 ? () => changePage(currentPage - 1) : null,
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 12,
          ),
        ),
        const SizedBox(width: 4),
        renderPageButtons(),
        const SizedBox(width: 4),
        PagerButton(
          onTap: currentPage + 1 <= totalPage
              ? () => changePage(currentPage + 1)
              : null,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 12,
          ),
        ),
        const SizedBox(width: 8),
        PagerButton(
          onTap: currentPage < totalPage ? () => changePage(totalPage) : null,
          child: const Icon(
            Icons.last_page_sharp,
            color: Colors.grey,
            size: 18,
          ),
        ),
        if (widget.showPageInput)
          Row(
            children: [
              const SizedBox(width: 8),
              const Text('Go to page'),
              const SizedBox(width: 4),
              SizedBox(
                width: 42,
                child: TextField(
                  controller: pageNumberController,
                  onSubmitted: (value) {
                    pageNumberController.clear();
                    final newPageIndex = int.parse(value);
                    if (newPageIndex > 0 && newPageIndex <= totalPage) {
                      changePage(newPageIndex);
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget renderItemDes() {
    final meta = widget.pageMeta;
    if (meta != null && meta.totalItems! > 0) {
      final startItemIndex = (meta.currentPage! - 1) * meta.itemsPerPage! + 1;
      return Text(
        'Result ${startItemIndex.toInt()}'
        '-${(startItemIndex + meta.itemCount! - 1).toInt()}'
        ' of ${meta.totalItems?.toInt()}',
      );
    }
    return const SizedBox();
  }

  Widget renderPageButtons() {
    final setPages = <Widget>[];
    final setButtons = totalPage == 0 ? {1} : {1, totalPage};
    const pageRange = 1;
    for (int i = max(currentPage - pageRange, 1);
        i <= min(currentPage + pageRange, totalPage);
        i++) {
      setButtons.add(i);
    }
    final pages = setButtons.toList()..sort((a, b) => a.compareTo(b));
    for (int i = 0; i < pages.length; i++) {
      final isSelected = currentPage == pages[i];
      setPages.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PagerButton(
            isSelected: isSelected,
            child: Text(
              pages[i].toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            ),
            onTap: () => changePage(pages[i]),
          ),
        ),
      );
      if (i + 1 < pages.length && pages[i + 1] - pages[i] > 1) {
        setPages.add(
          const Text('  ...  '),
        );
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: setPages,
    );
  }
}

class PagerButton extends StatelessWidget {
  const PagerButton({
    Key? key,
    required this.child,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: isSelected ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
