// lib/models/order_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return OrderItem(
      productId: doc.id,
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: data['price'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
