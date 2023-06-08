import 'package:flutter/material.dart';

class SelectorTile extends StatelessWidget {
  const SelectorTile({
    Key? key,
    required this.isSelected,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: isSelected ? Colors.red.withOpacity(0.06) : Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(child: child),
            if (isSelected)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
              ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
