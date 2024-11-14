import 'package:flutter/material.dart';
import 'package:mobile_project/pages/detail.dart';
import 'package:mobile_project/widgets/base_layout.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        child: ListView(padding: const EdgeInsets.all(10.0), children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                decoration: InputDecoration(
              prefixIcon: Icon(FluentIcons.search_12_regular),
              suffixIcon: Icon(FluentIcons.filter_12_filled),
              labelText: "Search",
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
            )),
          ),
        ],
      ),
      const Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 13.0, left: 18.0),
              child: Text("Football Court"),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.all(10.0),
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const Image(
                          width: 315.0,
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/football-court.jpg",
                          )),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0), // Applies padding to the entire Column
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("11 v 11 Court"),
                      // Gap
                      const SizedBox(height: 2.0),
                      const Text("20/hour",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2.0),
                      const Row(
                        children: [
                          Icon(
                            FluentIcons.location_12_regular,
                            size: 15.0,
                          ),
                          SizedBox(
                              width: 3.0), // Adds spacing between icon and text
                          Text("Complex Sport Center"),
                        ],
                      ),
                      const SizedBox(height: 8.0),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DetailPage()),
                          );
                        },
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        ],
      )
    ]));
  }
}
