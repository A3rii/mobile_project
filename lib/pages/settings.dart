import 'package:flutter/material.dart';
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
                child: const Text("Appearance & Language")),
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
                      onPressed: () {},
                      icon: const Icon(FluentIcons.local_language_16_regular)),
                  const Text("Language")
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
                      onPressed: () {},
                      icon:
                          const Icon(FluentIcons.weather_moon_off_16_regular)),
                  const Text("Dark mode")
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
