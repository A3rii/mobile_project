import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_project/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onTapNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;

      case 1:
        if (FirebaseAuth.instance.currentUser != null) {
          // signed in
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          // signed out
          Navigator.pushReplacementNamed(context, '/account');
        }

        break;

      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;

      default:
        Navigator.pushReplacementNamed(context, '/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      final localizations = AppLocalizations.of(context)!;
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green, // Highlight selected item color
        unselectedItemColor:
            const Color(0xFF526400), // Color for unselected items
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(FluentIcons.home_24_regular),
            activeIcon: const Icon(FluentIcons.home_24_filled),
            label: localizations.bottom_nav_1,
          ),
          BottomNavigationBarItem(
            icon: const Icon(FluentIcons.person_24_regular),
            activeIcon: const Icon(FluentIcons.person_24_filled),
            label: localizations.bottom_nav_2,
          ),
          BottomNavigationBarItem(
            icon: const Icon(FluentIcons.settings_24_regular),
            activeIcon: const Icon(FluentIcons.settings_24_filled),
            label: localizations.bottom_nav_3,
          ),
        ],
        onTap: _onTapNavigation,
      );
    });
  }
}
