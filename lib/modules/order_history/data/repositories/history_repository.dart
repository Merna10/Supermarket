import 'package:market/shared/models/order_list.dart';
import 'package:market/modules/order_history/data/services/history_service.dart';

class HistoryRepository {
  final HistoryService _historyService;

  HistoryRepository({HistoryService? historyService})
      : _historyService = historyService ?? HistoryService();

  Future<List<OrderList>> fetchOrders() {
    return _historyService.fetchOrders();
  }
}
