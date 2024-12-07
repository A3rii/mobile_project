import 'package:cloud_firestore/cloud_firestore.dart';

class UserApi {
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      // Transform each document to include its ID
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID
        return data;
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception("Failed to fetch courts: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
