import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/base/app_bar.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:mobile_project/services/court_api.dart';
import 'package:mobile_project/services/booking_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  final String courtId;
  const DetailPage({super.key, required this.courtId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // API
  final CourtApi courtApi = CourtApi();
  final BookingApi bookingApi = BookingApi();

  // Form Controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeStartController = TextEditingController();
  final TextEditingController timeEndController = TextEditingController();

  late Future<Map<String, dynamic>> courtFuture;

  // Selected DateTime objects
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    // Fetch court details based on courtId
    courtFuture = courtApi.getCourtById(widget.courtId);
  }

  @override
  void dispose() {
    // Clean up controllers
    dateController.dispose();
    timeStartController.dispose();
    timeEndController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        dateController.text = "${date.year}-${date.month}-${date.day}";
      });
    }
  }

  void _showTimePicker(
      TextEditingController controller, bool isStartTime) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (isStartTime) {
          startTime = time;
        } else {
          endTime = time;
        }
        controller.text = time.format(context);
      });
    }
  }

  Future<void> _submitBooking() async {
    if (selectedDate == null || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select date and time"),
        ),
      );
      return;
    }

    try {
      // Get the current user ID from Firebase Auth
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle the case where no user is logged in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not logged in"),
          ),
        );
        return;
      }

      final String userId = currentUser.uid;

      // Combine the selected date and time into DateTime objects
      final DateTime startDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        startTime!.hour,
        startTime!.minute,
      );

      final DateTime endDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      // Convert to Firebase Timestamp
      final Timestamp startTimestamp = Timestamp.fromDate(startDateTime);
      final Timestamp endTimestamp = Timestamp.fromDate(endDateTime);

      // Call the Booking API
      await bookingApi.requestBooking(
        courtId: widget.courtId,
        userId: userId,
        timeStart: startTimestamp,
        timeEnd: endTimestamp,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking successful!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Booking failed: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: courtFuture,
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
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Court details not available"));
          }

          final court = snapshot.data!;

          return ListView(
            children: [
              // Court image carousel
              SizedBox(
                height: 220.0,
                width: 300.0,
                child: AnotherCarousel(
                  images: court['images_preview'] != null
                      ? court['images_preview']
                          .map<Widget>(
                            (url) => ClipRRect(
                              child: Image.network(
                                url,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList()
                      : [const Icon(Icons.image_not_supported)],
                  dotSize: 5.0,
                  dotSpacing: 20.0,
                  dotColor: Colors.white,
                  indicatorBgPadding: 5.0,
                  dotBgColor: Colors.grey.withOpacity(0.5),
                  moveIndicatorFromBottom: 180.0,
                  noRadiusForIndicator: true,
                ),
              ),
              // Court name and description
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  court['name'] ?? "Unknown Court",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  court['desc'] ?? "Cannot load description",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Date and time pickers
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: dateController,
                  onTap: _showDatePicker,
                  readOnly: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(FluentIcons.calendar_12_regular),
                    labelText: "Select Date",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: timeStartController,
                        onTap: () => _showTimePicker(timeStartController, true),
                        readOnly: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(FluentIcons.clock_12_regular),
                          labelText: "Start",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: timeEndController,
                        onTap: () => _showTimePicker(timeEndController, false),
                        readOnly: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(FluentIcons.clock_12_regular),
                          labelText: "End",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Map<String, dynamic>>(
        future: courtFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final court = snapshot.data!;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0), // Rounded corners at the top
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Subtle shadow
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -1), // Shadow above
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Text(
                          "${court["price"]}\$/hour",
                          style: const TextStyle(
                            fontFamily: "Mont",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50, // Adjust button height
                  width: 150, // Adjust button width
                  child: ElevatedButton(
                    onPressed: _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Book now",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
