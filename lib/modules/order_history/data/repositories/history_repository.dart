import 'package:market/shared/models/order_list.dart';
import 'package:market/modules/order_history/data/services/history_service.dart';

class HistoryRepository {
  final HistoryService _historyService;

  HistoryRepository({HistoryService? historyService})
      : _historyService = historyService ?? HistoryService();

  Stream<List<OrderList>> fetchOrders({String status = 'All'}) {
    return _historyService.fetchOrders(status: status);
  }

  Stream<List<OrderList>> fetchUserOrders(
      {required String userId, String status = 'All'}) {
    return _historyService.fetchUserOrders(userId: userId, status: status);
  }

  Future<void> updateOrderStatus(
      {required String orderId, required String newStatus}) async {
    return _historyService.updateOrderStatus(
        orderId: orderId, newStatus: newStatus);
  }
}
