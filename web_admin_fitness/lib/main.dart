import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/app.dart';
import 'global/providers/app_settings_provider.dart';
import 'global/providers/auth_provider.dart';
import 'locator.dart';

void main() async {
  await setupLocator();
  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => locator.get<AuthProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}
