import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/modules/main/main_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/home_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/categories/categories_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/categories/category_upsert_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/exercises/exercise_upsert_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/exercises/exercises_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/inboxes_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/programs/program_upsert_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/user_upsert_page.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/users_manager_page.dart';
import 'package:web_admin_fitness/modules/main/modules/setting/edit_profile_page.dart';
import 'package:web_admin_fitness/modules/main/modules/setting/setting_page.dart';

import '../../modules/login/login_page.dart';
import '../../modules/main/modules/home/modules/inboxes/inbox_detail_page.dart';
import '../../modules/main/modules/home/modules/programs/programs_manager_page.dart';
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
      page: LoginPage,
      path: '/',
      initial: true,
    ),
    AutoRoute(
      path: '/main',
      page: MainPage,
      guards: [AuthGuard],
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
    NestedRoute(
      page: CategoryUpsertPage,
      path: 'categoryUpsert',
      guards: [AuthGuard],
      customRouteBuilder: rightSheetBuilder,
    ),
    NestedRoute(
      page: ProgramUpsertPage,
      path: 'programUpsert',
      guards: [AuthGuard],
      customRouteBuilder: rightSheetBuilder,
    ),
    NestedRoute(
      page: ExerciseUpsertPage,
      path: 'exerciseUpsert',
      customRouteBuilder: rightSheetBuilder,
    ),
    NestedRoute(
      page: UserUpsertPage,
      guards: [AuthGuard],
      path: 'userUpsert',
      customRouteBuilder: rightSheetBuilder,
    ),
    NestedRoute(
      page: InboxDetailPage,
      guards: [AuthGuard],
      path: 'inboxDetail',
      customRouteBuilder: rightSheetBuilder,
    ),
    NestedRoute(
      path: '/editProfile',
      page: EditProfilePage,
      guards: [AuthGuard],
      customRouteBuilder: rightSheetBuilder,
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
