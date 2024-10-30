import 'package:flutter/material.dart';
import 'package:mobile_project/widgets/base_layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      child: Center(
        child: (Text("Welcome to profile")),
      ),
    );
  }
}
