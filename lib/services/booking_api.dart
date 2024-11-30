import 'package:cloud_firestore/cloud_firestore.dart';

class BookingApi {
  // POST req for booking
  Future<DocumentReference<Object?>> requestBooking({
    required String courtId,
    required String userId,
    required Timestamp timeStart,
    required Timestamp timeEnd,
  }) async {
    try {
      // Getting Court by the id
      DocumentReference courtRef =
          FirebaseFirestore.instance.collection('courts').doc(courtId);

      // Getting User by the id
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Creating a booking req
      CollectionReference booking =
          FirebaseFirestore.instance.collection('bookings');
      return await booking.add({
        'court': courtRef, // Save the reference for the court
        'user': userRef, // Save the reference for the user
        'time_start': timeStart,
        'time_end': timeEnd,
        'status': "pending", // Convert DateTime to Firestore Timestamp
        'created_at':
            Timestamp.now(), // Optional: Track when booking is created
      });
    } on FirebaseException catch (e) {
      throw Exception("Failed to send bookings: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
