// lib/repositories/order_repository.dart
import 'package:market/modules/cart/data/models/order_list.dart';
import 'package:market/modules/cart/data/services/cart_service.dart';

class OrderRepository {
  final OrderService _orderService;

  OrderRepository({OrderService? orderService})
      : _orderService = orderService ?? OrderService();

  Future<void> addOrder(OrderList order, String userId) {
    return _orderService.addOrder(order, userId);
  }

  Future<List<OrderList>> fetchOrders(String userId) {
    return _orderService.fetchOrders(userId);
  }
}
