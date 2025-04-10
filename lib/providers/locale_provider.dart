import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';  // Add this import
import '../l10n/app_localizations.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  final Box _settingsBox = Hive.box('settings');

  LocaleProvider() {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLanguage = _settingsBox.get('language');
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Locale get locale => _locale;

  Future<void> setLocale(Locale newLocale) async {
    if (!AppLocalizations.supportedLocales.contains(newLocale)) return;
    if (_locale == newLocale) return;
    
    _locale = newLocale;
    await _settingsBox.put('language', newLocale.languageCode);
    notifyListeners();
  }
}