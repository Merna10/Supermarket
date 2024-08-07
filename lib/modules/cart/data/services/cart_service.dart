import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/shared/models/order_list.dart';

class OrderService {
  final FirebaseFirestore _firestore;

  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addOrder(OrderList orderList, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .add(orderList.toMap());
      print('Order added successfully for user $userId');
    } catch (e) {
      print('Failed to add order: $e');
      throw Exception('Failed to add order: $e');
    }
  }

  Future<List<OrderItem>> fetchCartItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      return snapshot.docs.map((doc) => OrderItem.fromMap(doc.data())).toList();
    } catch (e) {
      print('Failed to fetch cart items: $e');
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  Future<void> saveCartToUser(
      String userId, List<Map<String, dynamic>> cartData) async {
    try {
      final cartRef =
          _firestore.collection('users').doc(userId).collection('cart');
      WriteBatch batch = _firestore.batch();
      for (var item in cartData) {
        DocumentReference itemRef = cartRef.doc(); // Auto ID for each item
        batch.set(itemRef, item);
      }
      await batch.commit();
      print('Cart data saved successfully for user $userId');
    } catch (e) {
      print('Failed to save cart data: $e');
      throw Exception('Failed to save cart data: $e');
    }
  }

  Future<void> addItemToCart(OrderItem item, String userId) async {
    try {
      final cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.productId);

      await cartRef.set(item.toMap());
      print('Item added to cart successfully for user $userId');
    } catch (e) {
      print('Failed to add item to cart: $e');
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<void> removeItemFromCart(OrderItem item, String userId) async {
    try {
      final cartRef =
          _firestore.collection('users').doc(userId).collection('cart');
      final querySnapshot =
          await cartRef.where('productId', isEqualTo: item.productId).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print('Item removed from cart successfully for user $userId');
    } catch (e) {
      print('Failed to remove item from cart: $e');
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<void> updateItemQuantityInCart(
      OrderItem item, int quantity, String userId) async {
    try {
      final cartRef =
          _firestore.collection('users').doc(userId).collection('cart');
      final querySnapshot =
          await cartRef.where('productId', isEqualTo: item.productId).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'quantity': quantity});
      }
      print('Item quantity updated successfully for user $userId');
    } catch (e) {
      print('Failed to update item quantity: $e');
      throw Exception('Failed to update item quantity: $e');
    }
  }
  Future<int> getProductQuantity(String productId) async {
    final doc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
    return doc.data()?['quantity'] ?? 0;
  }

Future<bool> getAvailability(String productId) async {
  final doc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
  return doc.data()?['availability'] ?? false;
}


  Future<void> updateProductQuantity(String productId, int newQuantity,  ) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).update({'quantity': newQuantity});
  }

  Future<void> updateProductAvailability(String productId  ) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).update({'availability': false});
  }

  Future<void> clearCart(String userId) async {
    final cartCollection = FirebaseFirestore.instance.collection('users').doc(userId).collection('cart');
    final querySnapshot = await cartCollection.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
