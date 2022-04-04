import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classes_app/config/globals.dart' as Globle;

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");

  static var supportedLanguage = [
    Locale('en', 'US'),
    Locale('ar', 'DZ'),
    Locale('fr', 'FR'),
  ];

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  void changeLanguage(Locale type) async {
    print("languageCode::${type.languageCode}");
    var prefs = await SharedPreferences.getInstance();
    /*if (_appLocale == type) {
      return;
    }*/
    Globle.lang = type.languageCode;
    _appLocale = type;
    await prefs.setString('language_code', type.languageCode);
    await prefs.setString('countryCode', '');
    notifyListeners();
    return;
  }

}
