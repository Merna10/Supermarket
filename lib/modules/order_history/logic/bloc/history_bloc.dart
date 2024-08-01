import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/shared/models/order_list.dart';
import 'package:market/modules/order_history/data/repositories/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryBloc({required HistoryRepository HistoryRepository})
      : _historyRepository = HistoryRepository,
        super(HistoryInitial()) {
    on<FetchOrders>(_onFetchOrders);
  }

  void _onFetchOrders(FetchOrders event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final orders = await _historyRepository.fetchOrders();
      emit(HistoryLoaded(orders: orders));
    } catch (e) {
      emit(HistoryError(error: e.toString()));
    }
  }
}
