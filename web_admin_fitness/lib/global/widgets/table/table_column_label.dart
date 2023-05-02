import 'package:flutter/material.dart';

class GridColumnLabel extends StatelessWidget {
  const GridColumnLabel(
    this.label, {
    Key? key,
    this.action,
  }) : super(key: key);

  final String label;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: textTheme.titleSmall,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
