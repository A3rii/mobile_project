import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/providers/language_provider.dart';
import 'package:flag/flag.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: languageProvider.currentLocale.languageCode,
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Flag.fromCode(
                        FlagsCode.US,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "US",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  )),
            ),
            DropdownMenuItem(
              value: 'km',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Flag.fromCode(
                      FlagsCode.KH,
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "KH",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            )
          ],
          onChanged: (String? value) {
            if (value != null) {
              Provider.of<LanguageProvider>(context, listen: false)
                  .changeLocale(value);
            }
          },
        ),
      );
    });
  }
}
