import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';


class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Language / భాష ఎంచుకోండి',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Consumer<LocaleProvider>(
              builder: (context, provider, child) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await provider.setLocale(const Locale('en'));
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/splash');
                      }
                    },
                    child: const Text('English'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await provider.setLocale(const Locale('te'));
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/splash');
                      }
                    },
                    child: const Text('తెలుగు'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}