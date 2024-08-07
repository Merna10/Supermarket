import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String dimension;
  final String category;
  final String categoryID;
  final String collectionID;
  double quantity;
  final bool availability;
  final List<String> productImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.dimension,
    required this.category,
    required this.categoryID,
    required this.collectionID,
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
      dimension: data['dimension'] ?? '',
      category: data['category'] ?? '',
      categoryID: data['categoryID'] ?? '',
      collectionID: data['collectionID'] ?? '',
      quantity: data['quantity'].toDouble() ?? 0.0,
      availability: data['availability'] ?? false,
      productImage: List<String>.from(data['productImage']),
    );
  }

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'].toDouble() ?? 0.0,
      dimension: data['dimension'] ?? '',
      category: data['category'] ?? '',
      categoryID: data['categoryID'] ?? '',
      collectionID: data['collectionID'] ?? '',
      quantity: data['quantity'].toDouble() ?? 0.0,
      availability: data['availability'] ?? false,
      productImage: List<String>.from(data['productImage']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'dimension': dimension,
      'category': category,
      'categoryID': categoryID,
      'collectionID': collectionID,
      'quantity': quantity,
      'availability': availability,
      'productImage': productImage,
    };
  }
}
