import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/voice_booking_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/payment_screen.dart';
import 'package:hariva/l10n/app_localizations.dart';
import '../models/service_provider.dart';
import 'package:hariva/firebase_options.dart';
import 'screens/registration_screen.dart';
import 'providers/locale_provider.dart';
import 'screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'screens/language_selection_screen.dart';
import 'services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('settings');
  FirestoreService firestoreService = FirestoreService();

  // ✅ **Add TWO admin users on app startup**
  await firestoreService.addAdminUsers();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'FarmService Connect',
          theme: AppTheme.lightTheme,
          home: const AuthWrapper(),
          routes: {
            '/language': (context) => const LanguageSelectionScreen(),
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/booking':
                (context) => BookingScreen(
                  service:
                      ModalRoute.of(context)!.settings.arguments
                          as ServiceProvider,
                ),
            '/payment': (context) => const PaymentScreen(),
            '/admin': (context) => AdminDashboardScreen(),
            '/chatbot': (context) =>const  ChatbotScreen(),
            '/voice': (context) => const VoiceBookingScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/register': (context) => const RegistrationScreen(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomeScreen(); // ✅ If logged in, go to home
        } else {
          return const LanguageSelectionScreen(); // ✅ Start with language selection for new users
        }
      },
    );
  }
}
