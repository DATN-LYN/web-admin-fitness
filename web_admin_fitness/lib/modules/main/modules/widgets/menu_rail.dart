import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../global/gen/assets.gen.dart';
import '../../../../global/models/nav_item.dart';
import '../../../../global/routers/app_router.dart';
import 'menu_nav_tile.dart';

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
      width: isExpand ? 250.0 : 90.0,
      duration: duration,
      height: double.maxFinite,
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: widget.isMobile ? 50 : 30),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => AutoRouter.of(context).push(const HomeRoute()),
              splashFactory: NoSplash.splashFactory,
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Assets.images.logoContainer.path,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: widget.isMobile ? 0 : 30),
            Expanded(
              child: ListView(
                children: List.generate(
                  widget.navItems.length,
                  (index) => MenuNavTile(
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
