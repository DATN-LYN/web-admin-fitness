import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  const Tag({
    super.key,
    required this.text,
    required this.color,
    this.bgOpacity = 0.2,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 6,
    ),
    this.bgColor,
    this.fontSize = 14,
  });

  final String text;
  final Color color;
  final Color? bgColor;
  final double bgOpacity;
  final EdgeInsetsGeometry padding;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: bgColor ?? color.withOpacity(bgOpacity),
      ),
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium?.copyWith(
          color: color,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
