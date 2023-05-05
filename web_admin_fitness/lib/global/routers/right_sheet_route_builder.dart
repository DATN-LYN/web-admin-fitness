import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

Route<T> rightSheetBuilder<T>(
    BuildContext context, Widget child, CustomPage<T> page) {
  return RawDialogRoute(
    settings: page,
    pageBuilder: (context, animation1, animation2) {
      return _RightSheet(child: child);
    },
    transitionBuilder: (context, animation1, animation2, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        ).animate(animation1),
        child: child,
      );
    },
  );
}

class _RightSheet extends StatefulWidget {
  const _RightSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<_RightSheet> createState() => _RightSheetState();
}

class _RightSheetState extends State<_RightSheet> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGeneralDialog(
        context: context,
        barrierLabel: 'SideSheet',
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            alignment: Alignment.centerRight,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: widget.child,
              ),
            ],
          );
        },
        transitionBuilder: (context, a1, a2, widget) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: a1, curve: Curves.fastOutSlowIn),
            ),
            child: widget,
          );
        },
      ).then((value) {
        AutoRouter.of(context).popForced(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
