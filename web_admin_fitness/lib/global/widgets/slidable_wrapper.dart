import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../gen/i18n.dart';
import '../themes/app_colors.dart';

class SlidableWrapper extends StatelessWidget {
  const SlidableWrapper({
    super.key,
    required this.handleDelete,
    required this.child,
    required this.handleEdit,
    this.isView = false,
  });

  final VoidCallback handleDelete;
  final VoidCallback handleEdit;
  final Widget child;
  final bool isView;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            const SizedBox(width: 4),
            SlidableAction(
              onPressed: (context) => handleDelete(),
              icon: Icons.delete_outline,
              label: i18n.button_Delete,
              spacing: 10,
              backgroundColor: AppColors.deleteButton,
              foregroundColor: AppColors.grey1,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 8),
            SlidableAction(
              onPressed: (context) => handleEdit(),
              icon: isView ? Icons.visibility_outlined : Icons.edit_outlined,
              label: isView ? i18n.button_View : i18n.button_Edit,
              spacing: 10,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.grey1,
              borderRadius: BorderRadius.circular(8),
            )
          ],
        ),
        child: child);
  }
}
