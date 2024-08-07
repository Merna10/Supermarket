import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/products/data/models/product.dart';


class ProductService {
  final FirebaseFirestore _firestore;

  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Product>> fetchProductsByCategory(String categoryID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('categoryID',isEqualTo: categoryID)
          
          .get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<List<Product>> fetchProductsByCollection(String collectionID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('collectionID',isEqualTo: collectionID)
          
          .get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
   Future<int> fetchProductQuantity(String productId) async {
    try {
      final docSnapshot = await _firestore.collection('products').doc(productId).get();
      final data = docSnapshot.data();
      return data?['quantity'] ?? 0;
    } catch (e) {
      throw Exception('Error fetching product quantity: $e');
    }
  }
}
