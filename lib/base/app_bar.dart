import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text(
          "Football Rental Club",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green);
  }
}
