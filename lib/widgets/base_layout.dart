import 'package:flutter/material.dart';
import 'package:mobile_project/base/user/bottom_navigation.dart';
import 'package:mobile_project/base/user/app_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: child,
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
