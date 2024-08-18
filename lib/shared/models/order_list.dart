import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';

class OrderList {
  final String id;
  final String userId; // Added userId
  final List<OrderItem> items;
  final String status;
  final double total;
  final String userName;
  final String phoneNumber;
  final String deliveryAddress;
  final double deliveryFee;
  final DateTime date;

  OrderList({
    required this.id,
    required this.userId, // Added userId
    required this.items,
    required this.status,
    required this.userName,
    required this.phoneNumber,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.date,
  });

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      id: map['id'] as String,
      userId: map['userId'] as String, // Extract userId from map
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: map['status'] as String? ?? 'pending',
      userName: map['userName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      total: (map['total'] is int
              ? (map['total'] as int).toDouble()
              : map['total']) ??
          0.0,

      deliveryAddress: map['deliveryAddress'] as String? ?? '',
      deliveryFee: (map['deliveryFee'] is int
              ? (map['deliveryFee'] as int).toDouble()
              : map['deliveryFee']) ??
          0.0,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory OrderList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderList(
      id: doc.id,
      userId: data['userId'] as String, // Extract userId from document data
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      status: data['status'] as String? ?? 'pending',
      total: data['total'] ?? 0.0,
      userName: data['userName'] as String,
      phoneNumber: data['phoneNumber'] as String,
      deliveryAddress: data['deliveryAddress'] as String? ?? '',
      deliveryFee: data['deliveryFee'] ?? 0.0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
      'total': total,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'date': date,
    };
  }
}
