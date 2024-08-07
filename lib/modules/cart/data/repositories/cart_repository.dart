import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/data/services/cart_service.dart';
import 'package:market/shared/models/order_list.dart';

class OrderRepository {
  final OrderService _orderService;

  OrderRepository({OrderService? orderService})
      : _orderService = orderService ?? OrderService();

  Future<void> addOrder(OrderList orderList, String userId) async {
    return _orderService.addOrder(orderList, userId);
  }

  Future<List<OrderItem>> fetchCartItems(String userId) async {
    return _orderService.fetchCartItems(userId);
  }

  Future<void> saveCartToUser(
      String userId, List<Map<String, dynamic>> cartData) async {
    return _orderService.saveCartToUser(userId, cartData);
  }

  Future<void> addItemToCart(OrderItem item, String userId) async {
    return _orderService.addItemToCart(item, userId);
  }

  Future<void> removeItemFromCart(OrderItem item, String userId) async {
    return _orderService.removeItemFromCart(item, userId);
  }

  Future<void> updateItemQuantityInCart(
      OrderItem item, int quantity, String userId) async {
    return _orderService.updateItemQuantityInCart(item, quantity, userId);
  }

  Future<int> getProductQuantity(String productId)  async {
    return _orderService.getProductQuantity(productId);
  }

  Future<bool> getAvailability(String productId) async {
    return _orderService.getAvailability(productId);
  }

  Future<void> updateProductQuantity(
      String productId, int newQuantity, String userId) async {
    return _orderService.updateProductQuantity(productId, newQuantity,);
  }

   Future<void> updateProductAvailability(
      String productId,) async {
    return _orderService.updateProductAvailability(productId,  );
  }

  Future<void> clearCart(String userId) async {
    return _orderService.clearCart(userId);
  }
}
