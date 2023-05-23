import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';

import '../../global/models/nav_item.dart';
import '../../global/routers/app_router.dart';
import 'modules/widgets/home_header.dart';
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
    final isDesktopView = responsive.isLargerThan(MOBILE);
    final autoRoute = AutoRouter.of(context);
    String? genHeaderTitle() {
      final titles = {
        '/main/categories': i18n.main_Categories,
        '/main/setting': i18n.main_Setting,
        '/main/users': i18n.main_Users,
        '/main/programs': i18n.main_Programs,
        '/main/exercises': i18n.main_Programs,
        '/main/inboxes': i18n.main_Inboxes,
        '/main/home': i18n.main_Home,
      };
      for (final key in titles.keys) {
        if (autoRoute.currentUrl.contains(key)) {
          return titles[key];
        }
        return null;
      }
      return null;
    }

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
        label: i18n.main_Exercises,
        icon: Icons.video_collection_outlined,
        selectedIcon: Icons.video_collection_rounded,
        route: const ExercisesManagerRoute(),
      ),
      NavItem(
        label: i18n.main_Inboxes,
        icon: Icons.message_outlined,
        selectedIcon: Icons.message_rounded,
        route: const InboxesManagerRoute(),
      ),
      NavItem(
        label: i18n.main_Users,
        icon: Icons.account_circle_outlined,
        selectedIcon: Icons.account_circle_rounded,
        route: const UsersManagerRoute(),
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
        final title = genHeaderTitle();

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
              if (isDesktopView)
                MenuRail(
                  selectedIndex: tabsRouter.activeIndex,
                  onDestinationSelected: tabsRouter.setActiveIndex,
                  navItems: navItems,
                ),
              Expanded(
                child: Column(
                  children: [
                    if (title != null) HomeHeader(title: title),
                    Expanded(
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: isDesktopView
              ? null
              : Drawer(
                  child: SafeArea(
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
                ),
        );
      },
    );
  }
}
