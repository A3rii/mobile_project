import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_project/base/admin/app_bar.dart';
import 'package:mobile_project/base/admin/drawer.dart';
import 'package:mobile_project/services/booking_api.dart';
import 'package:mobile_project/services/user_api.dart';
import 'package:mobile_project/widgets/indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/providers/language_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final BookingApi bookingApi = BookingApi();
  final UserApi userApi = UserApi();
  late Future<Map<String, dynamic>> combinedFuture; // Combined future as a Map
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    // Combine the two API calls into a single Future that resolves to a Map
    // Array
    combinedFuture = Future.wait([
      bookingApi.getUsersBookings(),
      userApi.getAllUsers(),
    ]).then((results) {
      return {
        "bookings": results[0], // From BookingApi
        "users": results[1], // From UserApi
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      final localizations = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: const CustomAppbar(),
        drawer: const CustomDrawer(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: combinedFuture,
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
              return const Center(child: Text("No data available"));
            }

            final bookings =
                snapshot.data!["bookings"] as List<Map<String, dynamic>>;

            final users = snapshot.data!["users"] as List<Map<String, dynamic>>;

            int getStatusSize(String status) {
              return bookings
                  .where((booking) => booking['status'] == status)
                  .length;
            }

            final filterUsers = users.where((user) => user["role"] == "user");
            final totalUsers =
                users.where((user) => user["role"] == "user").length;

            return ListView(
              children: [
                const SizedBox(height: 10),
                // Booking Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statCard(localizations.total_booking, bookings.length,
                        Colors.green),
                    _statCard(
                        localizations.total_user, totalUsers, Colors.blue),
                    _statCard(localizations.total_pending,
                        getStatusSize("pending"), Colors.orange),
                  ],
                ),
                // Pie Chart for Bookings
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(5.0),
                  width: 350,
                  height: 350.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 13.0, left: 18.0),
                          child: Text(
                            "All Bookings",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Mont",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: showingSections(
                                  approvedBooking: getStatusSize("accepted"),
                                  pendingBooking: getStatusSize("pending"),
                                  rejectedBooking: getStatusSize("rejected"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Indicator(
                              color: Colors.green,
                              text: localizations.approved,
                              isSquare: true,
                            ),
                            const SizedBox(height: 4),
                            Indicator(
                              color: Colors.orange,
                              text: localizations.pending,
                              isSquare: true,
                            ),
                            const SizedBox(height: 4),
                            Indicator(
                              color: Colors.red,
                              text: localizations.reject,
                              isSquare: true,
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                        const SizedBox(width: 28),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.user_list,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Mont",
                        ),
                      ),
                      const SizedBox(height: 2),
                      ...filterUsers.map((user) => Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  user["name"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Mont",
                                  ),
                                ),
                                Text(
                                  user["email"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Mont",
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
    });
  }

//  Card
  Widget _statCard(String title, int count, Color? color) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: "Mont",
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections({
    required int approvedBooking,
    required int pendingBooking,
    required int rejectedBooking,
  }) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18 : 16;
      final double radius = isTouched ? 60 : 50;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: approvedBooking > 0 ? approvedBooking.toDouble() : 1,
            title: approvedBooking > 0 ? approvedBooking.toString() : '0',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orange,
            value: pendingBooking > 0 ? pendingBooking.toDouble() : 1,
            title: pendingBooking > 0 ? '$pendingBooking' : '0',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: rejectedBooking > 0 ? rejectedBooking.toDouble() : 1,
            title: rejectedBooking > 0 ? '$rejectedBooking' : '0',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
