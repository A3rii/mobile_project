import 'package:flutter/material.dart';
import 'package:mobile_project/base/admin/drawer.dart';
import 'package:mobile_project/base/admin/app_bar.dart';
import 'package:mobile_project/services/booking_api.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/providers/language_provider.dart';

class AcceptedPage extends StatefulWidget {
  const AcceptedPage({super.key});

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  final BookingApi bookingApi = BookingApi();
  late Future<List<Map<String, dynamic>>> bookingFuture;

  int? selectedRadio;
  String selectedValue = 'pending';

  @override
  void initState() {
    super.initState();
    fetchBookings();
    bookingFuture = bookingApi.getUsersBookings();
  }

  void fetchBookings() {
    setState(() {
      bookingFuture = bookingApi.getUsersBookings();
    });
  }

  void updateBookingStatus(String bookingId, String status) async {
    try {
      await bookingApi.updateBookingStatus(
          bookingId: bookingId, status: status);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status update successfully"),
        ),
      );
      fetchBookings();
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
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
          future: bookingFuture,
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
              return const Center(child: Text("No bookings available"));
            }

            final bookings = snapshot.data!;

            final filterPendingbookings = bookings
                .where((booking) => booking['status'] == selectedValue)
                .toList();

            return ListView(padding: const EdgeInsets.all(10.0), children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PopupMenuButton(
                    onSelected: (value) {
                      setState(() {
                        selectedValue = value;
                        switch (value) {
                          case 'pending':
                            selectedRadio = 1; // Pending
                            break;
                          case 'accepted':
                            selectedRadio = 2; // Accepted
                            break;
                          case 'rejected':
                            selectedRadio = 3; // Rejected
                            break;
                          default:
                            selectedRadio = 1;
                            break;
                        }
                      });
                    },
                    icon: const Icon(
                      FluentIcons.filter_12_filled,
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext bc) {
                      return [
                        PopupMenuItem(
                          value: 'pending',
                          child: ListTile(
                            title: Text(localizations.pending),
                            leading: Radio(
                              value: 1,
                              groupValue: selectedRadio, // Update this
                              onChanged: (value) {
                                setState(() {
                                  selectedRadio = value as int;
                                  selectedValue = 'pending';
                                });
                              },
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'accepted',
                          child: ListTile(
                            title: Text(localizations.approved),
                            leading: Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              onChanged: (value) {
                                setState(() {
                                  selectedRadio = value as int;
                                  selectedValue = 'accepted';
                                });
                              },
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'rejected',
                          child: ListTile(
                            title: Text(localizations.reject),
                            leading: Radio(
                              value: 3,
                              groupValue: selectedRadio, // Update this
                              onChanged: (value) {
                                setState(() {
                                  selectedRadio = value as int;
                                  selectedValue = 'rejected';
                                });
                              },
                            ),
                          ),
                        ),
                      ];
                    },
                  ),
                  Text(localizations.filter,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "Mont",
                          fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: filterPendingbookings.map((booking) {
                  final String bookingId = booking['id'] ?? 'unknown';

                  return Container(
                    margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              localizations.court,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Mont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking['court']?['name'] ?? 'Unknown Court',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Mont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(color: Colors.grey, thickness: 0.2),
                        const SizedBox(height: 10.0),
                        Text(
                          "${localizations.from},: ${booking['user']?['name'] ?? 'Unknown User'}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          "${localizations.phone}: ${booking['user']?['phoneNumber'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          "${localizations.status}: ${booking['status'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                backgroundColor:
                                    const Color.fromARGB(255, 214, 255, 230),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () =>
                                  updateBookingStatus(bookingId, 'accepted'),
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 14.0),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 214, 214),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () =>
                                  updateBookingStatus(bookingId, 'rejected'),
                              child: const Text(
                                'Deny',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            ]);
          },
        ),
      );
    });
  }
}
