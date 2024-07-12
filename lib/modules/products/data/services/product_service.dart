// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/products/data/models/product.dart';


class ProductService {
  final FirebaseFirestore _firestore;

  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('categories/$category/products')
          
          .get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
