import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../global/models/nav_item.dart';
import '../../global/routers/app_router.dart';
import 'modules/widgets/menu_rail.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final navItems = [
    NavItem(
      label: 'Home',
      icon: Icons.settings_remote_outlined,
      selectedIcon: Icons.settings_remote,
      route: const HomeRoute(),
    ),
    NavItem(
      label: 'Setting',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: const SettingRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: navItems.map((e) => e.route).toList(),
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: Row(
            children: [
              ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.largerThan(name: MOBILE)],
                child: MenuRail(
                  selectedIndex: tabsRouter.activeIndex,
                  onDestinationSelected: tabsRouter.setActiveIndex,
                  navItems: navItems,
                ),
              ),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: ResponsiveVisibility(
            visible: false,
            visibleWhen: const [Condition.smallerThan(name: TABLET)],
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
              items: List.generate(
                navItems.length,
                (index) => BottomNavigationBarItem(
                  icon: Icon(navItems[index].icon),
                  label: navItems[index].label,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
