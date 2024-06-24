import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    List<Product> products = [];

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories/$categoryId/products').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        products.add(Product.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print(e);
    }

    return products;
  }

  Future<Product?> fetchProductById(String productId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('products').doc(productId).get();
      if (doc.exists && doc.data() != null) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
