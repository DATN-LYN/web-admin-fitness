import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../modules/login/login_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
  ],
)
class AppRouter extends _$AppRouter {}
