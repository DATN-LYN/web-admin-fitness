
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.size = 40.0,
    this.name,
  }) : super(key: key);

  final double size;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Container(
          color: AppColors.grey6,
          alignment: Alignment.center,
          child: name != null && name!.length > 1
              ? Text(
                  name?.substring(0, 1).toUpperCase() ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                )
              : const Icon(Icons.person_outline),
        ),
      ),
    );
  }
}
