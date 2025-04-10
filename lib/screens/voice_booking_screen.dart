import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class VoiceBookingScreen extends StatelessWidget {
  const VoiceBookingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.voiceBookingTitle),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(localizations.voicePrompt),
                ElevatedButton(
                  onPressed: () {
                    // Voice booking logic
                  },
                  child: Text(localizations.startVoiceBooking),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
