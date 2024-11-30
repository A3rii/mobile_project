import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
                    Navigator.of(context).pop(); // Close the drawer
                  },
                ),
              ],
            ),
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.chart_multiple_16_filled,
            title: 'Dashboard',
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.approvals_app_16_filled,
            title: 'Accept Booking',
          ),
          _buildHoverableListTile(
            leadingIcon: FluentIcons.sign_out_20_filled,
            title: 'LogOut',
          ),
        ],
      ),
    );
  }

  Widget _buildHoverableListTile(
      {required IconData leadingIcon, required String title}) {
    return MouseRegion(
      onEnter: (event) {},
      onExit: (event) {},
      child: Material(
        color: Colors.transparent, // Default background color
        child: InkWell(
          onTap: () {}, // Add tap functionality here if needed
          hoverColor: Colors.grey[300], // Background color on hover
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
