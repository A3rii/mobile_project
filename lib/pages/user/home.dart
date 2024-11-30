import 'package:flutter/material.dart';
import 'package:mobile_project/pages/user/detail.dart';
import 'package:mobile_project/widgets/base_layout.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:mobile_project/services/court_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CourtApi courtApi = CourtApi();
  late Future<List<Map<String, dynamic>>> courtsFuture;

  @override
  void initState() {
    super.initState();
    courtsFuture = courtApi.getCourts();
  }

  void navigateToDetailPage(BuildContext context, String courtId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          courtId: courtId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: FutureBuilder<List<Map<String, dynamic>>>(
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
          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FluentIcons.search_12_regular,
                          color: Colors.green,
                        ),
                        suffixIcon: Icon(
                          FluentIcons.filter_12_filled,
                          color: Colors.green,
                        ),
                        labelText: "Search",
                        floatingLabelStyle: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Mont',
                          fontWeight: FontWeight.w300,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hoverColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(
                            color: Colors
                                .green, // Optional: color for focused border
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 13.0, left: 18.0),
                child: Text(
                  "Football Court",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Mont",
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: courts.map((court) {
                  final String courtId = court['id'] ?? 'unknown';
                  return Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        // Court Image
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              court['feature_image'] ??
                                  '', // Handle null image URL
                              width: 315.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 50.0,
                                );
                              },
                            ),
                          ),
                        ),
                        // Court Details
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${court['name'] ?? 'unknown'} court", // Handle null name
                                style: const TextStyle(
                                    fontFamily: 'Mont',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                "${court['price'] ?? '0'}\$/ hour", // Handle null price
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              const Row(
                                children: [
                                  Icon(
                                    FluentIcons.location_12_regular,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 3.0),
                                  Text(
                                    "Complex Sport Center",
                                    style: TextStyle(
                                      fontFamily: 'Mont',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (courtId != 'unknown') {
                                    navigateToDetailPage(context, court['id']);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Invalid court ID, cannot navigate."),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Mont',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
