import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'l10n/app_localizations.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  final Box _settingsBox = Hive.box('settings');

  LocaleProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;

  void _loadLocale() {
    String? savedLang = _settingsBox.get('language');
    if (savedLang != null &&
        AppLocalizations.supportedLocales.contains(Locale(savedLang))) {
      _locale = Locale(savedLang);
    }
    notifyListeners(); // Ensure this happens after initialization
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    if (_locale == locale) return;
    _locale = locale;
    await _settingsBox.put('language', locale.languageCode);
    notifyListeners();
  }
}