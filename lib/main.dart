import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/pages/account.dart';
import 'package:mobile_project/pages/detail.dart';
import 'package:mobile_project/pages/home.dart';
import 'package:mobile_project/pages/profile.dart';
import 'package:mobile_project/pages/settings.dart';
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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) => const LoginPage(),
        '/detail': (context) => const DetailPage(),
        '/account': (context) => const AccountPage(),
        '/signup': (context) => const SignUpPage()
      },
    );
  }
}
