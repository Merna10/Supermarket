// lib/bloc/order_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/data/models/order_list.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrderInitial()) {
    on<AddOrderItem>(_onAddOrderItem);
    on<SubmitOrder>(_onSubmitOrder);
    on<FetchOrders>(_onFetchOrders);
  }

  void _onAddOrderItem(AddOrderItem event, Emitter<OrderState> emit) {
    if (state is OrderInProgress) {
      final currentOrder = (state as OrderInProgress).order;
      final updatedOrder = OrderList(
        id: currentOrder.id,
        items: List.from(currentOrder.items)..add(event.orderItem),
        status: 'pending',
        total: currentOrder.total + (event.orderItem.price * event.orderItem.quantity),
      );
      emit(OrderInProgress(order: updatedOrder));
    } else {
      final newOrder = OrderList(
        id: 'tempOrderId', // Temporary ID until submission
        items: [event.orderItem],
        status: 'pending',
        total: event.orderItem.price * event.orderItem.quantity,
      );
      emit(OrderInProgress(order: newOrder));
    }
  }

  void _onSubmitOrder(SubmitOrder event, Emitter<OrderState> emit) async {
    if (state is OrderInProgress) {
      final currentOrder = (state as OrderInProgress).order;
      emit(OrderLoading());
      try {
        await _orderRepository.addOrder(currentOrder, event.userId);
        emit(OrderSubmitted());
      } catch (e) {
        emit(OrderError(error: e.toString()));
      }
    }
  }

  void _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.fetchOrders(event.userId);
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }
}
