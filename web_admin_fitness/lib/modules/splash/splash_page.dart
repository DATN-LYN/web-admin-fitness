import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../global/gen/assets.gen.dart';
import '../../global/routers/app_router.dart';
import '../../global/services/hive_service.dart';
import '../../global/themes/app_colors.dart';
import '../../locator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with ClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        final user = locator.get<HiveService>().getUserCredentials();
        if (user.accessToken != null) {
          AutoRouter.of(context).replaceAll([const MainRoute()]);
        } else {
          AutoRouter.of(context).push(const LoginRoute());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySoft,
      body: Center(
        child: Assets.images.logoContainer.image(width: 130, height: 130),
      ),
    );
  }
}
