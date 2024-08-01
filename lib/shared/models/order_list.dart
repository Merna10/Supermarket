import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';

class OrderList {
  final String id;
  final List<OrderItem> items;
  final String status;
  final double total;
  final String deliveryAddress;
  final double deliveryFee;
  final DateTime date;

  OrderList({
    required this.id,
    required this.items,
    required this.status,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.date,
  });

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      id: map['id'] as String,
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: map['status'] as String? ?? 'pending',
      total: map['total'] as double? ?? 0.0,
      deliveryAddress: map['deliveryAddress'] as String? ?? '',
      deliveryFee: map['deliveryFee'] as double? ?? 0.0,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory OrderList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderList(
      id: doc.id,
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      status: data['status'] as String? ?? 'pending',
      total: data['total'] as double? ?? 0.0,
      deliveryAddress: data['deliveryAddress'] as String? ?? '',
      deliveryFee: data['deliveryFee'] as double? ?? 0.0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'date': date,
    };
  }
}
