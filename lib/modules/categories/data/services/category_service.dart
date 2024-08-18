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

  Future<void> addCategory(Category category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id).set(category.toMap());
          
     } catch (e) {
      print('Failed to add category: $e');
      throw Exception('Failed to add categories: $e');
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id).delete();
          
     } catch (e) {
      print('Failed to delete category: $e');
      throw Exception('Failed to delete categories: $e');
    }
  }

  Future<String> fetchCategoryName(String categoryID) async {
  try {
    final docSnapshot = await _firestore.collection('categories').doc(categoryID).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return data?['name'] ?? 'Unknown Category'; 
    } else {
      throw Exception('Category not found');
    }
  } catch (e) {
    print('Failed to get category: $e');
    throw Exception('Failed to get category: $e');
  }
}

}
