import 'package:flutter/material.dart';
import 'package:mobile_project/pages/auth/login.dart';
import 'package:mobile_project/pages/user/home.dart';
import 'package:mobile_project/pages/auth/services/auth_service.dart';
import 'package:mobile_project/widgets/base_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> userDataFuture;

  // Handle Log out function
  Future<void> handleLogOut() async {
    try {
      await AuthService().logOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There is something wrong, try again!")),
      );
      throw Exception(e);
    }
  }

  // Getting data from document
  Future<Map<String, dynamic>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    final DocumentReference document =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    try {
      DocumentSnapshot snapshot = await document.get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found")),
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch data: ${e.message}")),
      );
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ));
          } else if (!snapshot.hasData || snapshot.data == null) {
            // If there's no data or the data is null, show a message or redirect
            return Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text(
                    "No user data available. Tap to return to Home."),
              ),
            );
          }

          final userData = snapshot.data!; // Safe to assume it's not null here

          return ListView(
            children: [
              const SizedBox(height: 25),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const ClipOval(
                    child: Image(
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/profile.jpg",
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    Text(
                      userData["name"] != null
                          ? "Hello, ${userData["name"]}!"
                          : "Hello, User!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData["email"] != null
                          ? "${userData["email"]}"
                          : "N/A",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, right: 100.0, left: 100.0),
                  child: ElevatedButton.icon(
                    onPressed: handleLogOut,
                    icon: const Icon(
                      FluentIcons.sign_out_20_regular,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    label: const Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
