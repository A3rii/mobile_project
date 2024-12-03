import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/services/booking_api.dart';
import 'package:mobile_project/widgets/base_layout.dart';
import 'package:intl/intl.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketState();
}

class _TicketState extends State<TicketPage> {
  final BookingApi bookingApi = BookingApi();
  late Future<List<Map<String, dynamic>>> bookingFuture;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  void fetchBookings() {
    setState(() {
      bookingFuture = bookingApi.getUsersBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: FutureBuilder<List<Map<String, dynamic>>>(
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

          final User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            // Handle the case where no user is logged in
            return const Center(child: Text("User not logged in"));
          }

          // Current User ID
          final String userId = currentUser.uid;

          // Filter bookings based on user ID
          final userBookings = snapshot.data!
              .where((booking) => booking['user']?['id'] == userId)
              .toList();

          // If no bookings are found
          if (userBookings.isEmpty) {
            return const Center(
                child: Text("No bookings found for this user."));
          }

          // Build the ListView for user-specific bookings
          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: userBookings.map((booking) {
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
                            color: Colors.green,
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
                      "Date: ${DateFormat('dd-MMMM-yyyy').format(booking['time_start'].toDate())}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Time: ${DateFormat('hh:mm a').format(booking['time_start'].toDate())}-${DateFormat('hh:mm a').format(booking['time_end'].toDate())}   ",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Status: ${booking['status'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
