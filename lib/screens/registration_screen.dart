import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'package:hariva/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String phone = '';
  String email = '';
  String verificationId = '';
  String otp = '';
  bool isPhone = true;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          key: navigatorKey,
          appBar: AppBar(title: Text(localizations.register)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => name = value,
                  decoration: InputDecoration(labelText: localizations.farmName),
                ),
                if (isPhone) ...[
                  TextField(
                    onChanged: (value) => phone = value,
                    decoration: InputDecoration(labelText: localizations.phoneNumber),
                    keyboardType: TextInputType.phone,
                  ),
                ] else ...[
                  TextField(
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(labelText: localizations.email),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
                SwitchListTile(
                  title: Text(localizations.registerWithEmail),
                  value: !isPhone,
                  onChanged: (value) => setState(() => isPhone = !value),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (name.isEmpty ||
                        (isPhone && phone.isEmpty) ||
                        (!isPhone && email.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations.fillAllFields)),
                      );
                      return;
                    }
                    if (isPhone) {
                      await _authService.signInWithPhone(phone, (vid) {
                        setState(() => verificationId = vid);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.emailOtpNotImplemented),
                        ),
                      );
                    }
                  },
                  child: Text(localizations.sendOtp),
                ),
                if (verificationId.isNotEmpty || !isPhone) ...[
                  TextField(
                    onChanged: (value) => otp = value,
                    decoration: InputDecoration(labelText: localizations.enterOtp),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (otp.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.enterOtpPrompt)),
                        );
                        return;
                      }
                      if (isPhone) {
                        User? user = await _authService.verifyOtp(
                          verificationId,
                          otp,
                        );
                        if (user != null) {
                          await _firestore.collection('users').doc(user.uid).set({
                            'name': name,
                            'phone': phone,
                            'email': email,
                          });
                          navigatorKey.currentState!.pushReplacementNamed('/home');
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localizations.invalidOtp)),
                            );
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.emailOtpNotImplemented),
                          ),
                        );
                      }
                    },
                    child: Text(localizations.verifyOtp),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}