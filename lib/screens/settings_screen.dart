import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settings),
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: DropdownButton<String>(
                  value: localeProvider.locale.languageCode,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      localeProvider.setLocale(Locale(newValue));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}