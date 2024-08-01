import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/shared/models/order_list.dart';

class OrderService {
  final FirebaseFirestore _firestore;

  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addOrder(OrderList order) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId != null) {
        await _firestore.collection('users').doc(userId).collection('orders').add(order.toMap());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<OrderList>> fetchOrders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId != null) {
       QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('orders').get();
        return snapshot.docs.map((doc) => OrderList.fromFirestore(doc)).toList();
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
