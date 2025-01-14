import 'package:flutter/material.dart';
import 'package:mobile_project/pages/user/edit_profile.dart';
import 'package:mobile_project/pages/user/ticket.dart';
import 'package:mobile_project/widgets/base_layout.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        child: ListView(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicketPage(),
                          ),
                        );
                      },
                      icon: const Icon(FluentIcons.ticket_diagonal_16_regular)),
                  const Text("Tickets")
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                      icon: const Icon(FluentIcons.person_12_regular)),
                  const Text("Edit Profile")
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
