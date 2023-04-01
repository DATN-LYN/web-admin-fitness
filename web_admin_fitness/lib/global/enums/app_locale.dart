import 'dart:io';

import 'package:flutter/material.dart';

import '../gen/i18n.dart';

enum AppLocale {
  auto('auto'),
  enUs('en_US'),
  viVN('vi_VN');

  final String value;
  const AppLocale(this.value);

  static AppLocale fromValue(String? value) {
    return AppLocale.values.firstWhere(
      (e) => e.value.contains(value ?? ''),
      orElse: () => auto,
    );
  }

  Locale toLocale() {
    switch (this) {
      case enUs:
        return const Locale('en', 'US');
      case viVN:
        return const Locale('vi', 'VN');
      default:
        final codes = Platform.localeName;
        return Locale(codes.split('_')[0]);
    }
  }

  // String getLabel(I18n i18n) {
  //   return toLocale().languageCode.contains('en')
  //       ? i18n.language[0]
  //       : i18n.language[1];
  // }
}
