// lib/bloc/order_state.dart
part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderList> orders;

  const OrderLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String error;

  const OrderError({required this.error});

  @override
  List<Object> get props => [error];
}

class OrderAdded extends OrderState {}

class OrderSubmitted extends OrderState {}

class OrderInProgress extends OrderState {
  final OrderList order;

  const OrderInProgress({required this.order});

  @override
  List<Object> get props => [order];
}
