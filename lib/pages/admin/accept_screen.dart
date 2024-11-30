import 'package:flutter/material.dart';
import 'package:mobile_project/base/admin/drawer.dart';
import 'package:mobile_project/base/admin/app_bar.dart';

class AcceptedPage extends StatefulWidget {
  const AcceptedPage({super.key});

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        drawer: const CustomDrawer(),
        body: ListView(children: [
          const SizedBox(height: 20.0),
          Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(20.0),
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: 12.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text("Match Acception",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 0.2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text("Nam Kimly"),
                          Text("010253374"),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0), // Smaller padding
                              backgroundColor:
                                  const Color.fromARGB(255, 214, 255, 230),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0, // Removes the shadow
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.0, // Smaller font size
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8, // Slightly smaller gap
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 214, 214),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0, // Removes the shadow
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Deny',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0, // Smaller font size
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ))
        ]));
  }
}
