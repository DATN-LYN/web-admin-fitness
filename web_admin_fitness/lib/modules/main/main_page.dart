import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';

import '../../global/models/nav_item.dart';
import '../../global/routers/app_router.dart';
import 'modules/widgets/menu_rail.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final isMobileView = responsive.isSmallerThan(TABLET);
    final i18n = I18n.of(context)!;
    final navItems = [
      NavItem(
        label: i18n.main_Home,
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        route: const HomeRoute(),
      ),
      NavItem(
        label: i18n.main_Categories,
        icon: Icons.category_outlined,
        selectedIcon: Icons.category,
        route: const CategoriesManagerRoute(),
      ),
      NavItem(
        label: i18n.main_Programs,
        icon: Icons.view_list_outlined,
        selectedIcon: Icons.view_list_rounded,
        route: const ProgramsManagerRoute(),
      ),
      NavItem(
        label: i18n.main_Setting,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: const SettingRoute(),
      ),
    ];

    return AutoTabsRouter(
      routes: navItems.map((e) => e.route).toList(),
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: isMobileView
              ? AppBar(
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                )
              : null,
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
          drawer: Drawer(
            child: MenuRail(
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: (index) {
                tabsRouter.setActiveIndex(index);
                context.popRoute();
              },
              navItems: navItems,
              isMobile: true,
            ),
          ),
        );
      },
    );
  }
}
