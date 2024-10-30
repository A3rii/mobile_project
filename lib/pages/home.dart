import 'package:flutter/material.dart';
import 'package:mobile_project/widgets/base_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      child: Center(
        child: Text('Welcome to the Sport Rental!'),
      ),
    );
  }
}
