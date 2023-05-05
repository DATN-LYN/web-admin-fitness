import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/toast_item.dart';
import '../../themes/app_colors.dart';

class ToastTile extends StatelessWidget {
  const ToastTile({
    Key? key,
    required this.animation,
    required this.item,
    this.isRemoving = false,
    this.onRemove,
  }) : super(key: key);
  final Animation<double> animation;
  final ToastItem item;
  final bool isRemoving;
  final void Function(ToastItem item)? onRemove;

  @override
  Widget build(BuildContext context) {
    final child = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: item.iconColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(
                      item.leadingIcon,
                      color: item.iconColor,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            item.subtitle,
                            overflow: TextOverflow.visible,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => onRemove?.call(item),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.grey1,
                          size: 18,
                        ),
                        splashRadius: 5,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isRemoving) {
      return SlideTransition(
        position: Tween(
          begin: kIsWeb ? const Offset(1, 0) : const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(animation),
        child: child,
      );
    }
    return SizeTransition(
      sizeFactor: animation,
      child: child,
    );
  }
}
