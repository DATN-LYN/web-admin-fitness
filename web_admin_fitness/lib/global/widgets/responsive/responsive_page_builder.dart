import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../extensions/responsive_wrapper.dart';

class ResponsivePageBuilder extends StatefulWidget {
  const ResponsivePageBuilder({
    Key? key,
    required this.header,
    required this.listView,
    required this.tableView,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget header;
  final Widget listView;
  final Widget tableView;
  final Widget? floatingActionButton;

  @override
  State<ResponsivePageBuilder> createState() => _ResponsivePageBuilderState();
}

class _ResponsivePageBuilderState extends State<ResponsivePageBuilder>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    super.initState();
  }

  bool _scrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      if (notification.metrics.pixels < 50) {
        animationController.animateTo(0);
      } else {
        animationController.animateTo(1);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final spacing = responsive.adap(16.0, 24.0);
    final isDesktopView = responsive.isLargerThan(MOBILE);
    final child = Stack(
      children: [
        Column(
          children: [
            if (isDesktopView)
              widget.header
            else
              SizeTransition(
                sizeFactor: Tween<double>(
                  begin: 1,
                  end: 0,
                ).animate(animationController),
                child: widget.header,
              ),
            Expanded(
              child: isDesktopView ? widget.tableView : widget.listView,
            ),
          ],
        ),
        if (widget.floatingActionButton != null)
          Positioned(
            right: spacing,
            bottom: 32,
            child: widget.floatingActionButton!,
          ),
      ],
    );

    if (isDesktopView) {
      return child;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _scrollNotification,
      child: child,
    );
  }
}
