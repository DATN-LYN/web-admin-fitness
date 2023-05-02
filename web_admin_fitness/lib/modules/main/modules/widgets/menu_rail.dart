import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';

import '../../../../global/gen/assets.gen.dart';
import '../../../../global/models/nav_item.dart';
import '../../../../global/routers/app_router.dart';

class MenuRail extends StatefulWidget {
  const MenuRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.navItems,
    this.isMobile = false,
  });

  final int selectedIndex;
  final List<NavItem> navItems;
  final Function(int) onDestinationSelected;
  final bool isMobile;

  @override
  State<MenuRail> createState() => _MenuRailState();
}

class _MenuRailState extends State<MenuRail> {
  late bool isExpand = widget.isMobile ? true : false;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 150);

    return AnimatedContainer(
      width: isExpand ? 240.0 : 70.0,
      duration: duration,
      height: double.maxFinite,
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: widget.isMobile ? 50 : 0),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => AutoRouter.of(context).push(const MainRoute()),
                child: Center(
                  child: Assets.images.logoContainer.image(
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: widget.isMobile ? 0 : 30),
            Expanded(
              child: ListView(
                children: List.generate(
                  widget.navItems.length,
                  (index) => _RailItem(
                    item: widget.navItems[index],
                    duration: duration,
                    isExpand: isExpand,
                    isSelected: index == widget.selectedIndex,
                    onTap: () => widget.onDestinationSelected(index),
                  ),
                ),
              ),
            ),
            Divider(color: Colors.grey.shade500),
            if (!widget.isMobile)
              IconButton(
                onPressed: () => setState(() => isExpand = !isExpand),
                icon: Icon(
                  isExpand
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    Key? key,
    required this.item,
    required this.duration,
    required this.isExpand,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final NavItem item;
  final Duration duration;
  final bool isExpand;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.9)
            : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: isSelected
                      ? Icon(item.selectedIcon, color: AppColors.grey1)
                      : Icon(item.icon),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: duration,
                  child: isExpand
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? AppColors.grey1 : null,
                              height: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
