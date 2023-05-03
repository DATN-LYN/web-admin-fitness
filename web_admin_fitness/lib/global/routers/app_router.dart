import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_admin_fitness/modules/main/main_page.dart';
import 'package:web_admin_fitness/modules/main/modules/accounts/users_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/categories/categories_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/exercises/exercises_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/home_page.dart';
import 'package:web_admin_fitness/modules/main/modules/inboxes/inboxes_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/setting/setting_page.dart';

import '../../modules/login/login_page.dart';
import '../../modules/main/modules/programs/programs_manager_page.dart';
import 'nested_route.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: LoginPage,
      path: '/',
      initial: true,
    ),
    AutoRoute(
      path: '/main',
      page: MainPage,
      children: [
        NestedRoute(
          page: HomePage,
          path: 'home',
        ),
        NestedRoute(
          page: SettingPage,
          path: 'setting',
        ),
        NestedRoute(
          page: CategoriesManagerPage,
          path: 'categories',
        ),
        NestedRoute(
          page: ProgramsManagerPage,
          path: 'programs',
        ),
        NestedRoute(
          page: ExercisesManagerPage,
          path: 'exercises',
        ),
        NestedRoute(
          page: InboxesManagerPage,
          path: 'inboxes',
        ),
        NestedRoute(
          page: UsersManagerPage,
          path: 'users',
        ),
      ],
    ),
    // AutoRoute(
    //   page: MainPage,
    //   path: '/main',
    //   initial: true,
    // ),
    // AutoRoute(
    //   page: HomePage,
    //   path: '/home',
    //   initial: true,
    // ),
    // AutoRoute(
    //   page: SettingPage,
    //   path: '/setting',
    //   initial: true,
    // ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class AppRouter extends _$AppRouter {}
