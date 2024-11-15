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
            apiKey: "AIzaSyDwQ4nar1ug7IYzY9gszxCjkWtecL9jj_Q",
            authDomain: "flutter-project-4b8ad.firebaseapp.com",
            projectId: "flutter-project-4b8ad",
            storageBucket: "flutter-project-4b8ad.firebasestorage.app",
            messagingSenderId: "920868618173",
            appId: "1:920868618173:web:9e52f8e9e08c53dda79cd4"));
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
