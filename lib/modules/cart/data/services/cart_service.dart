// lib/services/order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/cart/data/models/order_list.dart';

class OrderService {
  final FirebaseFirestore _firestore;

  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addOrder(OrderList order, String userId) async {
    try {
      await _firestore.collection('users/$userId/orders').add(order.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<OrderList>> fetchOrders(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users/$userId/orders').get();
      return snapshot.docs.map((doc) => OrderList.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
