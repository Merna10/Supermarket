import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/products/data/models/product.dart';

class QuantityManager {
  final Product product;
  int quantity = 0;

  QuantityManager(this.product);

  Future<void> loadQuantity() async {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (isLoggedIn) {
      await _loadQuantityFromFirestore();
    } else {
      await _loadQuantityFromHive();
    }
  }

  Future<void> _loadQuantityFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        quantity = data?['quantity'] ?? 0;
      } else {
        quantity = 0;
      }
    } catch (e) {
      print('Error loading quantity from Firestore: $e');
    }
  }

  Future<void> _loadQuantityFromHive() async {
    try {
      var box = await Hive.openBox<OrderItem>('order');
      final existingItem = box.values.firstWhere(
        (item) => item.productId == product.id,
        orElse: () => OrderItem(
          productId: product.id,
          productName: product.name,
          quantity: 0,
          price: product.price,
          productImage: product.productImage.isNotEmpty
              ? product.productImage.first
              : '',
        ),
      );

      quantity = existingItem.quantity;
    } catch (e) {
      print('Error loading quantity from Hive: $e');
    }
  }

  void incrementQuantity() {
    if (quantity < product.quantity) {
      quantity++;
    }
  }

  void decrementQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }
}
