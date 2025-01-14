import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_project/widgets/language_selector.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/providers/language_provider.dart';

class CustomUserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomUserAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.appTitle, // Localized app title
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const LanguageSelector(), // Language selector dropdown
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
