import 'package:cloud_firestore/cloud_firestore.dart';

class BookingApi {
  // POST req for bookings
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

  // Bookings for admin
  Future<List<Map<String, dynamic>>> getUsersBookings() async {
    try {
      // Fetch all bookings
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("bookings").get();

      // Transform each booking document
      return await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Check if `user` reference exists and fetch its data
        if (data['user'] is DocumentReference) {
          DocumentSnapshot userSnapshot = await data['user'].get();
          data['user'] = userSnapshot.data();
        }

        // Check if `court` reference exists and fetch its data
        if (data['court'] is DocumentReference) {
          DocumentSnapshot courtSnapshot = await data['court'].get();
          data['court'] = courtSnapshot.data();
        }

        return data;
      }).toList());
    } on FirebaseException catch (e) {
      throw Exception("Failed to fetch bookings: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
