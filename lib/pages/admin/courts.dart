import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/base/admin/app_bar.dart';
import 'package:mobile_project/base/admin/drawer.dart';
import 'package:mobile_project/pages/admin/create_court.dart';
import 'package:mobile_project/pages/admin/delete_court.dart';
import 'package:mobile_project/pages/admin/edit_court.dart';
import 'package:mobile_project/services/court_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_project/providers/language_provider.dart';
import 'package:provider/provider.dart';

class Court extends StatefulWidget {
  const Court({super.key});

  @override
  State<Court> createState() => _CourtState();
}

class _CourtState extends State<Court> {
  final CourtApi courtApi = CourtApi();
  late Future<List<Map<String, dynamic>>> courtsFuture;

  @override
  void initState() {
    super.initState();
    courtsFuture = courtApi.getCourts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      final localizations = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: const CustomAppbar(),
        drawer: const CustomDrawer(),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: courtsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No courts available"));
            }

            final courts = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      FluentIcons.add_12_regular,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddingCourt()));
                    },
                    label: Text(
                      localizations.add_court,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Mont',
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3,
                    ),
                    itemCount: courts.length,
                    itemBuilder: (context, index) {
                      final court = courts[index];
                      final String courtId = court['id'] ?? 'unknown';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      court['feature_image'] ?? '',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image,
                                          size: 50.0,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        court['name'] ?? "No Name",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Price: \$${court['price']?.toString() ?? "0"}",
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditCourt(
                                                    courtId: courtId,
                                                  )));
                                    },
                                    icon: const Icon(
                                      FluentIcons.pen_16_regular,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      DeleteCourt.deleteCourtModal(
                                          context, courtId);
                                    },
                                    icon: const Icon(
                                      FluentIcons.bin_full_20_regular,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
