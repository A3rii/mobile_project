import 'package:flutter/material.dart';
import 'package:mobile_project/base/admin/drawer.dart';
import 'package:mobile_project/base/admin/app_bar.dart';
import 'package:mobile_project/services/booking_api.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class AcceptedPage extends StatefulWidget {
  const AcceptedPage({super.key});

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  final BookingApi bookingApi = BookingApi();
  late Future<List<Map<String, dynamic>>> bookingFuture;

  @override
  void initState() {
    super.initState();
    bookingFuture = bookingApi.getUsersBookings();
  }

  @override
  Widget build(BuildContext context) {
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

          return ListView(padding: const EdgeInsets.all(10.0), children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FluentIcons.filter_12_filled,
                    color: Colors.black,
                  ),
                ),
                const Text("Filter",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Mont",
                        fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: bookings.map((booking) {
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
                          const Text(
                            "Court ",
                            style: TextStyle(
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
                        "From: ${booking['user']?['name'] ?? 'Unknown User'}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Phone: ${booking['user']?['phoneNumber'] ?? 'N/A'}",
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
                            onPressed: () {},
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
                            onPressed: () {},
                            child: const Text(
                              'Deny',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
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
  }
}
