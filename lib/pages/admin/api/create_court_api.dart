import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCourt {
  Future<void> createCourt({
    required String court,
    required int price,
    required String description,
    required String fileUrl,
    required String image1,
    required String image2,
    required String image3,
  }) async {
    try {
      CollectionReference courtRef =
          FirebaseFirestore.instance.collection('courts');

      await courtRef.add({
        'name': court,
        'price': price,
        'desc': description,
        'feature_image': fileUrl,
        'images_preview': [image1, image2, image3]
      });
    } catch (err) {
      rethrow;
    }
  }
}
