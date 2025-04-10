import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hariva/l10n/app_localizations.dart';
import 'package:hariva/providers/locale_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return ListTile(
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
        );
      },
    );
  }
}
