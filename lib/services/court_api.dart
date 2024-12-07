import 'package:cloud_firestore/cloud_firestore.dart';

class CourtApi {
  // Fetch all courts data
  Future<List<Map<String, dynamic>>> getCourts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("courts").get();

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

// Getting by id
  Future<Map<String, dynamic>> getCourtById(String courtId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("courts")
          .doc(courtId)
          .get(); // Fetch a single document by ID

      if (!docSnapshot.exists) {
        throw Exception("Court with ID $courtId does not exist.");
      }

      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data == null || data.isEmpty) {
        throw Exception(
            "Court data is invalid or empty for document ID: $courtId");
      }

      // Optionally, include the document ID
      data['id'] = docSnapshot.id;

      return data;
    } on FirebaseException catch (e) {
      throw Exception("Failed to fetch court from Firestore: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
