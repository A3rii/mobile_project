import 'package:cloud_firestore/cloud_firestore.dart';

class EditCourtApi {
  // Updating Court
  Future<void> updateCourt(
      {required String courtId,
      required String name,
      required String featureImage,
      required List<String> images,
      required double price,
      required String description}) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("courts").doc(courtId);

      await documentReference.update({
        "name": name,
        "price": price,
        "desc": description,
        'feature_image': featureImage,
        'images_preview': images,
      });
    } on FirebaseException catch (e) {
      throw Exception("Failed to update court: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
