import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateOrderService {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('order');

  Future<void> updateOrder({
    required String user,
    required int numberOfPeople,
    required double totalPrice,
    required double finalPrice,
    required double discount,
    required List<dynamic> items,
    required String status,
    required String email,
  }) async {
    var snapshot = await _orderCollection.where('user', isEqualTo: user).get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;

      return await _orderCollection.doc(doc.id).update({
        'number_of_people': numberOfPeople,
        'total_price': totalPrice,
        'final_price': finalPrice,
        'discount': discount,
        'items': items,
        'status': status,
        'email': email,
      });
    } else {
      throw Exception('Order not found');
    }
  }
}
