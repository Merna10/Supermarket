import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
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
  Future<List<OrderItem>> fetchCartItems(String userId) async {
    try {
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return cartSnapshot.docs.map((doc) {
        final data = doc.data();
        return OrderItem.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }
}
