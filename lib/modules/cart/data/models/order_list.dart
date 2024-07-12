
// lib/models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';


class OrderList {
  final String id;
  final List<OrderItem> items;
  final String status;
  final double total;

  OrderList({
    required this.id,
    required this.items,
    required this.status,
    required this.total,
  });

  factory OrderList.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return OrderList(
      id: doc.id,
      items: (data['items'] as List).map((item) => OrderItem.fromFirestore(item)).toList(),
      status: data['status'] ?? 'pending',
      total: data['total'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
      'total': total,
    };
  }
}
