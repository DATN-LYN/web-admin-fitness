import 'package:auto_route/auto_route.dart';

import '../../locator.dart';
import '../services/hive_service.dart';
import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = locator.get<HiveService>().getUserCredentials();

    if (user.accessToken != null) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
