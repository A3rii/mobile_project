import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/pages/detail.dart';
import 'package:mobile_project/pages/home.dart';
import 'package:mobile_project/pages/profile.dart';
import 'package:mobile_project/pages/settings.dart';
import 'package:mobile_project/pages/auth/sign-up.dart';
import 'package:mobile_project/pages/auth/login.dart';

void main() {
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
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/detail': (context) => const DetailPage(),
      },
    );
  }
}