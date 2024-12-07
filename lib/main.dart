import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/pages/admin/accept_screen.dart';
import 'package:mobile_project/pages/admin/dashboard.dart';
import 'package:mobile_project/pages/user/account.dart';
import 'package:mobile_project/pages/user/home.dart';
import 'package:mobile_project/pages/user/ticket.dart';
import 'package:mobile_project/pages/user/profile.dart';
import 'package:mobile_project/pages/user/settings.dart';
import 'package:mobile_project/pages/auth/sign-up.dart';
import 'package:mobile_project/pages/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDRuGsspm_KdTRuKOOd2oZZWlLC5_sMnc8",
            authDomain: "flutter-project-8c05e.firebaseapp.com",
            projectId: "flutter-project-8c05e",
            storageBucket: "flutter-project-8c05e.firebasestorage.app",
            messagingSenderId: "1071973866337",
            appId: "1:1071973866337:web:7d977f4e15692abaa38320"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) => const LoginPage(),
        '/account': (context) => const AccountPage(),
        '/signup': (context) => const SignUpPage(),
        '/ticket': (context) => const TicketPage(),
        '/accept': (context) => const AcceptedPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
