import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String dimension;
  final String categoryID;
  final String collectionID;
  double quantity;
  final DateTime dateAdded;
  final bool availability;
  bool isFavorite;
  final List<String> productImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.dimension,
    required this.categoryID,
    required this.collectionID,
    required this.quantity,
    required this.availability,
    required this.isFavorite,
    required this.productImage,
    required this.dateAdded, 
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'].toDouble() ?? 0.0,
      dimension: data['dimension'] ?? '',
      categoryID: data['categoryID'] ?? '',
      collectionID: data['collectionID'] ?? '',
      quantity: data['quantity'].toDouble() ?? 0.0,
      availability: data['availability'] ?? false,
      isFavorite: data['isFavorite'] ?? false,
      productImage: List<String>.from(data['productImage']),
      dateAdded: (data['dateAdded'] as Timestamp).toDate(),
    );
  }

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'].toDouble() ?? 0.0,
      dimension: data['dimension'] ?? '',
      categoryID: data['categoryID'] ?? '',
      collectionID: data['collectionID'] ?? '',
      quantity: data['quantity'].toDouble() ?? 0.0,
      availability: data['availability'] ?? false,
      isFavorite: data['isFavorite'] ?? false,
      productImage: List<String>.from(data['productImage']),
      dateAdded: (data['dateAdded'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'dimension': dimension,
      'categoryID': categoryID,
      'collectionID': collectionID,
      'quantity': quantity,
      'availability': availability,
      'isFavorite': isFavorite,
      'productImage': productImage,
      'dateAdded': Timestamp.fromDate(dateAdded), 
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? dimension,
    String? categoryID,
    String? collectionID,
    double? quantity,
    DateTime? dateAdded,
    bool? availability,
    bool? isFavorite,
    List<String>? productImage,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      dimension: dimension ?? this.dimension,
      categoryID: categoryID ?? this.categoryID,
      collectionID: collectionID ?? this.collectionID,
      quantity: quantity ?? this.quantity,
      availability: availability ?? this.availability,
      isFavorite: isFavorite ?? this.isFavorite,
      productImage: productImage ?? this.productImage,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
