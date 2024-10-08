// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/en.dart';
import 'translations/zh_cn.dart';

class AppTranslations extends Translations {
  
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'zh_CN': zhCN,
      };

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('zh', 'CN'),
  ];

  static const fallbackLocale = Locale('zh');

  static const localizationsDelegates = [
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];
  
}
