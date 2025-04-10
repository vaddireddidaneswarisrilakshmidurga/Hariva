import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  String phone = '';
  String? verificationId;
  String otp = '';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          key: navigatorKey,
          appBar: AppBar(title: Text(localizations.login)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => phone = value,
                  decoration: InputDecoration(labelText: localizations.phoneNumber),
                  keyboardType: TextInputType.phone,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _authService.signInWithPhone(phone, (vid) {
                      setState(() => verificationId = vid);
                    });
                  },
                  child: Text(localizations.sendOtp),
                ),
                if (verificationId != null) ...[
                  TextField(
                    onChanged: (value) => otp = value,
                    decoration: InputDecoration(labelText: localizations.enterOtp),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      User? user = await _authService.verifyOtp(
                        verificationId!,
                        otp,
                      );
                      if (user != null)
                        navigatorKey.currentState!.pushReplacementNamed('/home');
                    },
                    child: Text(localizations.verifyOtp),
                  ),
                ],
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                    );
                  },
                  child: Text(localizations.registerPrompt),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}