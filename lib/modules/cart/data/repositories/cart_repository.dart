import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/shared/models/order_list.dart';

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository(this._firestore);

  Future<void> addOrder(OrderList orderList, String userId) async {
    final ordersRef = _firestore.collection('users').doc(userId).collection('orders');
    await ordersRef.add(orderList.toMap());
  }

  Future<List<OrderList>> fetchOrders(String userId) async {
    final ordersSnapshot = await _firestore.collection('users').doc(userId).collection('orders').get();
    return ordersSnapshot.docs.map((doc) => OrderList.fromMap(doc.data())).toList();
  }
}
