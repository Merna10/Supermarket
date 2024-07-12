// lib/services/category_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/categories/data/models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore;

  CategoryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Category>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
