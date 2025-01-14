import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/widgets/language_selector.dart';
import 'package:mobile_project/providers/language_provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      final localizations = AppLocalizations.of(context)!;
      return AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            localizations.sport_admin,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Mont',
                fontWeight: FontWeight.bold),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(FluentIcons.list_16_filled),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          backgroundColor: Colors.white,
          actions: const [
            // Add the LanguageSelector widget in the AppBar's actions
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: LanguageSelector(),
            )
          ]);
    });
  }
}
