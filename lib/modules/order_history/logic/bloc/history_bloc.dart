import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/shared/models/order_list.dart';
import 'package:market/modules/order_history/data/repositories/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;
  StreamSubscription<List<OrderList>>? _orderListSubscription;

  HistoryBloc({required HistoryRepository historyRepository})
      : _historyRepository = historyRepository,
        super(HistoryInitial()) {
    on<FetchUserOrders>(_onFetchUserOrders);
    on<FetchOrders>(_onFetchOrders);
    on<HistoryLoaded>(_onOrderssLoaded);
    on<HistoryError>(_onHistoryError);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }
void _onFetchOrders(FetchOrders event, Emitter<HistoryState> emit) {
  emit(HistoryLoading());
  _orderListSubscription?.cancel();

  try {
    _orderListSubscription = _historyRepository.fetchOrders(status: event.status).listen(
      (orders) {
        add(HistoryLoaded(orders: orders));
      },
      onError: (error) {
        add(HistoryError(error: error.toString()));
      },
    );
  } catch (e) {
    add(HistoryError(error: e.toString()));
  }
}

void _onFetchUserOrders(FetchUserOrders event, Emitter<HistoryState> emit) {
  emit(HistoryLoading());
  _orderListSubscription?.cancel();

  try {
    _orderListSubscription = _historyRepository.fetchUserOrders(userId: event.userId, status: event.status).listen(
      (orders) {
        add(HistoryLoaded(orders: orders));
      },
      onError: (error) {
        add(HistoryError(error: error.toString()));
      },
    );
  } catch (e) {
    add(HistoryError(error: e.toString()));
  }
}


  void _onOrderssLoaded(HistoryLoaded event, Emitter<HistoryState> emit) {
    emit(HistoryLoadedList(orders: event.orders));
  }

  void _onHistoryError(HistoryError event, Emitter<HistoryState> emit) {
    emit(HistoryErrors(error: event.error));
  }

Future<void> _onUpdateOrderStatus(UpdateOrderStatus event, Emitter<HistoryState> emit) async {
    try {
      await _historyRepository.updateOrderStatus(orderId: event.orderId, newStatus: event.newStatus);
      emit(StatusUpdateSuccess());
    } catch (e) {
      emit(HistoryErrors(error: e.toString()));
    }
  }
  
  @override
  Future<void> close() {
    _orderListSubscription?.cancel();
    return super.close();
  }
}
