import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

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
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
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
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green, // Highlight selected item color
      unselectedItemColor:
          const Color(0xFF526400), // Color for unselected items
      selectedFontSize: 14,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FluentIcons.home_24_regular),
          activeIcon: Icon(FluentIcons.home_24_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FluentIcons.person_24_regular),
          activeIcon: Icon(FluentIcons.person_24_filled),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(FluentIcons.settings_24_regular),
          activeIcon: Icon(FluentIcons.settings_24_filled),
          label: 'Settings',
        ),
      ],
      onTap: _onTapNavigation,
    );
  }
}
