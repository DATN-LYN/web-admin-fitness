import 'package:flutter/material.dart';

import '../../../../global/gen/assets.gen.dart';
import '../../../../global/models/nav_item.dart';
import 'menu_nav_tile.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key? key,
    required this.selectedIndex,
    required this.navItems,
    required this.onDestinationSelected,
  }) : super(key: key);

  final int selectedIndex;
  final List<NavItem> navItems;
  final Function(int) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Assets.images.logo.image(),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: List.generate(
                  navItems.length,
                  (index) => MenuNavTile(
                    item: navItems[index],
                    duration: const Duration(milliseconds: 150),
                    isExpand: true,
                    isSelected: index == selectedIndex,
                    onTap: () {
                      onDestinationSelected(index);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
