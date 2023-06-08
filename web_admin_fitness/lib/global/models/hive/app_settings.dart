import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/app_locale.dart';
import '../../enums/app_theme.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings([
    @Default(AppLocale.auto) AppLocale locale,
    @Default(AppTheme.auto) AppTheme theme,
    @Default(true) bool isFirstLaunch,
  ]) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
