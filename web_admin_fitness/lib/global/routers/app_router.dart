import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/modules/main/main_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/home_page.dart';
import 'package:web_admin_fitness/modules/main/modules/setting/edit_profile_page.dart';
import 'package:web_admin_fitness/modules/main/modules/setting/setting_page.dart';
import 'package:web_admin_fitness/modules/splash/splash_page.dart';

import '../../modules/login/login_page.dart';
import '../../modules/main/modules/categories/categories_manager_page.dart';
import '../../modules/main/modules/categories/category_upsert_page.dart';
import '../../modules/main/modules/exercises/exercise_upsert_page.dart';
import '../../modules/main/modules/exercises/exercises_manager_page.dart';
import '../../modules/main/modules/inboxes/inbox_detail_page.dart';
import '../../modules/main/modules/inboxes/inboxes_manager_page.dart';
import '../../modules/main/modules/programs/program_upsert_page.dart';
import '../../modules/main/modules/programs/programs_manager_page.dart';
import '../../modules/main/modules/users/user_upsert_page.dart';
import '../../modules/main/modules/users/users_manager_page.dart';
import '../graphql/fragment/__generated__/category_fragment.data.gql.dart';
import '../graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import '../graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import '../graphql/fragment/__generated__/program_fragment.data.gql.dart';
import '../graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'auth_guard.dart';
import 'nested_route.dart';
import 'right_sheet_route_builder.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: SplashPage,
      path: '/',
      initial: true,
    ),
    AutoRoute(
      page: LoginPage,
      path: '/login',
    ),
    AutoRoute(
      path: '/main',
      page: MainPage,
      guards: [AuthGuard],
      children: [
        NestedRoute(
          page: HomePage,
          path: 'home',
          initial: true,
        ),
        NestedRoute(
          page: EmptyRouterPage,
          path: 'settings',
          name: 'SettingsRoute',
          children: [
            NestedRoute(
              page: SettingPage,
              path: '',
              initial: true,
            ),
            NestedRoute(
              path: 'profile',
              page: EditProfilePage,
              customRouteBuilder: rightSheetBuilder,
            ),
          ],
        ),
        NestedRoute(
          page: EmptyRouterPage,
          path: 'categories',
          name: 'CategoriesRoute',
          children: [
            NestedRoute(
              page: CategoriesManagerPage,
              path: '',
              initial: true,
            ),
            NestedRoute(
              page: CategoryUpsertPage,
              path: 'upsert',
              customRouteBuilder: rightSheetBuilder,
            ),
          ],
        ),
        NestedRoute(
          page: EmptyRouterPage,
          path: 'programs',
          name: 'ProgramsRoute',
          children: [
            NestedRoute(
              page: ProgramsManagerPage,
              path: '',
              initial: true,
            ),
            NestedRoute(
              page: ProgramUpsertPage,
              path: 'upsert',
              customRouteBuilder: rightSheetBuilder,
            ),
          ],
        ),
        NestedRoute(
          page: EmptyRouterPage,
          path: 'exercises',
          name: 'ExercisesRoute',
          children: [
            NestedRoute(
              page: ExercisesManagerPage,
              path: '',
              initial: true,
            ),
            NestedRoute(
              page: ExerciseUpsertPage,
              path: 'upsert',
              customRouteBuilder: rightSheetBuilder,
            ),
          ],
        ),
        NestedRoute(
          page: EmptyRouterPage,
          path: 'inboxes',
          name: 'InboxesRoute',
          children: [
            NestedRoute(
              page: InboxesManagerPage,
              path: '',
              initial: true,
            ),
            NestedRoute(
              page: InboxDetailPage,
              path: 'detail',
              customRouteBuilder: rightSheetBuilder,
            ),
          ],
        ),
        NestedRoute(
          page: EmptyRouterPage,
          path: 'users',
          name: 'UsersRoute',
          children: [
            NestedRoute(
              page: UsersManagerPage,
              path: '',
              initial: true,
            ),
            NestedRoute(
              page: UserUpsertPage,
              path: 'upsert',
              customRouteBuilder: rightSheetBuilder,
            ),
          ],
        ),
      ],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({
    required super.authGuard,
  });
}

class RightSheetRouter extends StatelessWidget {
  const RightSheetRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(child: AutoRouter());
  }
}
