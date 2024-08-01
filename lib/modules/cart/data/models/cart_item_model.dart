import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'order_item.g.dart';

@HiveType(typeId: 0)
class OrderItem {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String productImage;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.productImage,
  });

  factory OrderItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderItem(
      productId: doc.id,
      productName: data['productName'] as String? ?? '',
      quantity: data['quantity'] as int? ?? 0,
      price: data['price'] as double? ?? 0.0,
      productImage: data['productImage'] as String? ?? '',
    );
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      price: map['price'] as double? ?? 0.0,
      productImage: map['productImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'productImage': productImage,
    };
  }

  OrderItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? price,
    String? productImage,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productImage: productImage ?? this.productImage,
    );
  }
}
