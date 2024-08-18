import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market/modules/products/data/models/product.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  final FirebaseFirestore _firestore;

  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Product>> fetchProductsByCategory(String categoryID) {
    try {
      return _firestore
          .collection('products')
          .where('categoryID', isEqualTo: categoryID)
          .orderBy('dateAdded', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Product>> fetchProductsByCollection(String collectionID) {
    try {
      return _firestore
          .collection('products')
          .where('collectionID', isEqualTo: collectionID)
          .orderBy('dateAdded', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<int> fetchProductQuantity(String productId) {
    try {
      return _firestore.collection('products').doc(productId).snapshots().map(
        (docSnapshot) {
          final data = docSnapshot.data();
          return data?['quantity'] ?? 0;
        },
      );
    } catch (e) {
      throw Exception('Error fetching product quantity: $e');
    }
  }

  Stream<List<Product>> fetchFavoriteProducts(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('dateAdded', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getCollectionDetails(
      String collectionId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('collections').doc(collectionId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching collection details: $e');
      return null;
    }
  }

  Future<void> addToFavorites(String userId, Product product) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(product.id)
          .set(product.toMap());
    } catch (e) {
      print("Failed to add favorite: $e");
    }
  }

  Future<bool> isProductFavorite(String userId, String productId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .get();

      return doc.exists;
    } catch (e) {
      print("Error checking if product is favorite: $e");
      return false;
    }
  }

  Future<void> removeFromFavorites(String userId, Product product) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(product.id)
          .delete();
    } catch (e) {
      print("Failed to remove favorite: $e");
    }
  }

  Future<void> addProduct(Product product, List<File>? imageFiles) async {
    try {
      List<String> imageUrls = [];

      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (var imageFile in imageFiles) {
          final String fileName = const Uuid().v4();
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('productImages')
              .child('$fileName.jpg');

          await storageRef.putFile(imageFile);
          final imageUrl = await storageRef.getDownloadURL();
          imageUrls.add(imageUrl);
        }
      }

      final newProduct = Product(
        id: product.id,
        availability: true,
        categoryID: product.categoryID,
        collectionID: product.collectionID,
        dateAdded: DateTime.now(),
        dimension: product.dimension,
        name: product.name,
        isFavorite: false,
        price: product.price,
        productImage: imageUrls,
        quantity: product.quantity,
      );

      await _firestore
          .collection('products')
          .doc(newProduct.id)
          .set(newProduct.toMap());
    } catch (e) {
      print('Failed to add product: $e');
      throw Exception('Failed to add product: $e');
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
      return product;
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<void> sendEmailNotification(
      String adminEmail, String subject, String body) async {
    const sendGridApiKey = '';
    const sendGridEndpoint = 'https://api.sendgrid.com/v3/mail/send';

    final emailData = {
      'personalizations': [
        {
          'to': [
            {'email': adminEmail}
          ],
          'subject': subject,
        }
      ],
      'from': {'email': ''},
      'content': [
        {'type': 'text/plain', 'value': body}
      ]
    };

    final response = await http.post(
      Uri.parse(sendGridEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $sendGridApiKey',
      },
      body: jsonEncode(emailData),
    );

    if (response.statusCode == 202) {
      print('Notification sent to admin.');
    } else {
      print('Failed to send notification: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
