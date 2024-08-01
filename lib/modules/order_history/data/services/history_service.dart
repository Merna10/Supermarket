import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/shared/models/order_list.dart';

class HistoryService {
  final FirebaseFirestore _firestore;

  HistoryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<OrderList>> fetchOrders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId == null) {
        throw Exception('User is not logged in');
      }

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      return snapshot.docs
          .map((doc) {
            try {
              return OrderList.fromFirestore(doc);
            } catch (e) {
              print('Error processing document ${doc.id}: ${e.toString()}');
              return null; // Or handle as per your error strategy
            }
          })
          .whereType<OrderList>()
          .toList();
    } catch (e) {
      print('Failed to fetch orders: ${e.toString()}');
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }
}
