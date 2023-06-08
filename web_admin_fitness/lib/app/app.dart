import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:web_admin_fitness/global/routers/auth_guard.dart';

import '../global/gen/i18n.dart';
import '../global/providers/app_settings_provider.dart';
import '../global/routers/app_router.dart';
import '../global/themes/app_colors.dart';
import '../global/themes/app_themes.dart';
import 'app_scroll_behavior.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _appRouter = AppRouter(authGuard: AuthGuard());

  @override
  Widget build(BuildContext context) {
    FormBuilderLocalizations.delegate.load(const Locale('en', 'US'));

    return Consumer<AppSettingsProvider>(
      builder: (context, provider, child) {
        return MaterialApp.router(
          title: 'My App',
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          localizationsDelegates: const [
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: I18n.delegate.supportedLocales,
          locale: provider.localeData,
          localeResolutionCallback: I18n.delegate.resolution(
            fallback: const Locale('en', 'US'),
          ),
          theme: AppThemes.light(),
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          builder: (context, child) {
            return SfDataGridTheme(
              data: SfDataGridThemeData(
                headerColor: AppColors.neutral20,
                frozenPaneLineColor: Colors.transparent,
              ),
              child: ResponsiveWrapper.builder(
                child,
                minWidth: 300,
                defaultScale: true,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(300, name: MOBILE),
                  ResponsiveBreakpoint.resize(850, name: TABLET),
                  ResponsiveBreakpoint.resize(1080, name: DESKTOP),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<AppSettingsProvider>().fetch();
        break;
      default:
    }
  }
}
