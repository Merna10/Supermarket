import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/shared/models/order_list.dart';

class HistoryService {
  final FirebaseFirestore _firestore;

  HistoryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<OrderList>> fetchOrders({String status = 'All'}) {
    try {
      var query =
          _firestore.collection('orders').orderBy('date', descending: true);

      if (status != 'All') {
        query = query.where('status', isEqualTo: status);
      }

      return query.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => OrderList.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<OrderList>> fetchUserOrders(
      {required String userId, String status = 'All'}) {
    try {
      var query = _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true);

      if (status != 'All') {
        query = query.where('status', isEqualTo: status);
      }

      return query.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => OrderList.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

   Future<void> updateOrderStatus({required String orderId, required String newStatus}) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }
}
