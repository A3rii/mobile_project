import 'package:cloud_firestore/cloud_firestore.dart';

class CourtApi {
  // Fetch all courts data
  Future<List<Map<String, dynamic>>> getCourts() async {
    try {
      // Get all documents from the "courts" collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("courts").get();

      // Check if there are any documents
      if (snapshot.docs.isEmpty) {
        throw Exception("No courts found in the database.");
      }

      List<Map<String, dynamic>> courts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;

        // If data is null or empty, skip this document
        if (data == null || data.isEmpty) {
          throw Exception(
              "Court data is invalid or empty for document ID: ${doc.id}");
        }

        return data;
      }).toList();

      return courts;
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      throw Exception("Failed to fetch courts from Firestore: ${e.message}");
    } catch (e) {
      // Catch any other errors
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
