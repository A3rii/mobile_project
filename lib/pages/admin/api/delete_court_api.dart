import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteCourtApi {
  Future<void> deleteCourt({required String courtId}) async {
    final DocumentReference courtRef =
        FirebaseFirestore.instance.collection('courts').doc(courtId);

    try {
      final docSnapshot = await courtRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Court with ID $courtId does not exist.');
      }
      await courtRef.delete();
    } catch (e) {
      rethrow;
    }
  }
}
