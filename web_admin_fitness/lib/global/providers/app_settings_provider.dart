import 'package:flutter/material.dart';

import '../../locator.dart';
import '../enums/app_locale.dart';
import '../enums/app_theme.dart';
import '../gen/i18n.dart';
import '../models/hive/app_settings.dart';
import '../services/hive_service.dart';

class AppSettingsProvider extends ChangeNotifier {
  final _hiveService = locator.get<HiveService>();

  late AppSettings appSettings;

  AppSettingsProvider() {
    appSettings = _hiveService.getAppSettings();
  }

  ThemeData get themeData => appSettings.theme.toThemeData();

  Locale get localeData => appSettings.locale.toLocale();

  void changeTheme(AppTheme theme) async {
    await _hiveService.saveTheme(theme);
    appSettings = _hiveService.getAppSettings();
    notifyListeners();
  }

  void changeLocale(AppLocale locale) async {
    await _hiveService.saveLocale(locale);
    appSettings = _hiveService.getAppSettings();
    I18n.locale = locale.toLocale();
    notifyListeners();
  }

  void reset() async {
    appSettings = await _hiveService.resetAppSettings();
    notifyListeners();
  }

  void fetch() async {
    appSettings = _hiveService.getAppSettings();
    notifyListeners();
  }
}
