import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  double quantity;
  final bool availability;
  final String productImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.availability,
    required this.productImage,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'].toDouble() ?? 0.0,
      category: data['category'] ?? '',
      quantity: data['quantity'].toDouble() ?? 0.0,
      availability: data['availability'] ?? false,
      productImage: data['productImage'] ?? '',
    );
  }

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'].toDouble() ?? 0.0,
      category: data['category'] ?? '',
      quantity: data['quantity'].toDouble() ?? 0.0,
      availability: data['availability'] ?? false,
      productImage: data['productImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'quantity': quantity,
      'availability': availability,
      'productImage': productImage,
    };
  }
}
