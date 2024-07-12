// lib/models/category.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({required this.id, required this.name,required this.imageUrl});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
