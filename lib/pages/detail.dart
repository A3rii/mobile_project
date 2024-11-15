import 'package:flutter/material.dart';
import 'package:mobile_project/widgets/base_layout.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Method to show the date picker
  void _showDatePicker() {
    BottomPicker.date(
      pickerTitle: const Text(
        'Select Your Date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      initialDateTime: DateTime(1996, 10, 22),
      maxDateTime: DateTime(1998),
      minDateTime: DateTime(1980),
      pickerTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      onChange: (index) {},
      onSubmit: (index) {},
    ).show(context);
  }

  // Method to show the time picker
  void _showTimePicker() {
    BottomPicker.time(
      pickerTitle: const Text(
        'Time',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      onSubmit: (index) {},
      onClose: () {},
      use24hFormat: true,
      initialTime: Time(
        minutes: 23,
      ),
      maxTime: Time(
        hours: 17,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: ListView(
        children: [
          SizedBox(
            height: 220.0,
            width: 300.0,
            child: AnotherCarousel(
              images: const [
                ExactAssetImage("assets/images/football-court.jpg"),
                ExactAssetImage("assets/images/football-court-1.jpg"),
                ExactAssetImage("assets/images/football-court-2.jpg")
              ],
              dotSize: 7.0,
              dotSpacing: 20.0,
              dotColor: Colors.white,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.green.withOpacity(0.5),
              borderRadius: true,
              moveIndicatorFromBottom: 180.0,
              noRadiusForIndicator: true,
            ),
          ),
          const SizedBox(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                softWrap: true,
                "An 11v11 football field, or pitch, is a rectangular playing surface with specific markings and dimensions. It typically ranges from 100 to 130 yards in length and 50 to 100 yards in width. The field is marked with lines that define the touchlines, goal lines, penalty areas, and center circle.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onTap: _showDatePicker, // Trigger the date picker when tapped
              readOnly:
                  true, // Make the TextField read-only so it acts like a button
              decoration: const InputDecoration(
                suffixIcon: Icon(FluentIcons.calendar_12_regular),
                labelText: "Select Date",
                floatingLabelStyle: TextStyle(color: Colors.green),
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
                    color: Colors.green, // Optional: color for focused border
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  // First TextField for Start time
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0), // Add space between TextFields
                      child: TextField(
                        onTap: _showTimePicker,
                        readOnly: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            FluentIcons.clock_12_regular,
                            size: 20,
                          ),
                          labelText: "Start",
                          floatingLabelStyle: TextStyle(color: Colors.green),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hoverColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Second TextField for End time
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0), // Add space between TextFields
                      child: TextField(
                        onTap: _showTimePicker,
                        readOnly: true,
                        decoration: const InputDecoration(
                          suffixIcon:
                              Icon(FluentIcons.clock_12_regular, size: 20),
                          labelText: "End",
                          floatingLabelStyle: TextStyle(color: Colors.green),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hoverColor: Colors.white,
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
              )),
        ],
      ),
    );
  }
}
