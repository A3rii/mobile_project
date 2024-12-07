import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:mobile_project/pages/auth/login.dart';
import 'package:mobile_project/pages/auth/services/auth_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Handle Log out function
  Future<void> handleLogOut() async {
    try {
      await AuthService().logOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      return;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There is something wrong, try again!")),
      );
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    FluentIcons.dismiss_12_filled,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.chart_multiple_16_filled,
            title: 'Dashboard',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.approvals_app_16_filled,
            title: 'Accept Booking',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/accept');
            },
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.add_square_16_filled,
            title: 'Create Court',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.sign_out_20_filled,
            title: 'Log Out',
            onTap: () => handleLogOut(),
          ),
        ],
      ),
    );
  }

  Widget _buildHoverableListTile(
      {required IconData leadingIcon,
      required String title,
      required Function() onTap}) {
    return MouseRegion(
      onEnter: (event) {},
      onExit: (event) {},
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.grey[300],
          child: ListTile(
            leading: Icon(leadingIcon),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
