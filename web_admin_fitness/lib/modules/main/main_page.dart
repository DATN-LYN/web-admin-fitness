import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';

import '../../global/models/nav_item.dart';
import '../../global/routers/app_router.dart';
import 'modules/widgets/home_header.dart';
import 'modules/widgets/menu_drawer.dart';
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
    final i18n = I18n.of(context)!;
    final isDesktopView = responsive.isLargerThan(MOBILE);
    final autoRoute = AutoRouter.of(context);
    String? genHeaderTitle() {
      final titles = {
        '/main/home': i18n.main_Home,
        '/main/categories': i18n.main_Categories,
        '/main/programs': i18n.main_Programs,
        '/main/exercises': i18n.main_Exercises,
        '/main/inboxes': i18n.main_Inboxes,
        '/main/users': i18n.main_Users,
        '/main/setting': i18n.main_Setting,
      };
      for (final key in titles.keys) {
        if (autoRoute.currentUrl.contains(key)) {
          return titles[key];
        }
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
        route: const CategoriesRoute(),
      ),
      NavItem(
        label: i18n.main_Programs,
        icon: Icons.view_list_outlined,
        selectedIcon: Icons.view_list_rounded,
        route: const ProgramsRoute(),
      ),
      NavItem(
        label: i18n.main_Exercises,
        icon: Icons.video_collection_outlined,
        selectedIcon: Icons.video_collection_rounded,
        route: const ExercisesRoute(),
      ),
      NavItem(
        label: i18n.main_Inboxes,
        icon: Icons.message_outlined,
        selectedIcon: Icons.message_rounded,
        route: const InboxesRoute(),
      ),
      NavItem(
        label: i18n.main_Users,
        icon: Icons.account_circle_outlined,
        selectedIcon: Icons.account_circle_rounded,
        route: const UsersRoute(),
      ),
      NavItem(
        label: i18n.main_Setting,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: const SettingsRoute(),
      ),
    ];

    return AutoTabsRouter(
      routes: navItems.map((e) => e.route).toList(),
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        final title = genHeaderTitle();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: isDesktopView
              ? null
              : MenuDrawer(
                  selectedIndex: tabsRouter.activeIndex,
                  onDestinationSelected: tabsRouter.setActiveIndex,
                  navItems: navItems,
                ),
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
        );
      },
    );
  }
}
