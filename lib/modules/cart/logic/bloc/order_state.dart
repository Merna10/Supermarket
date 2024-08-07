part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderError extends OrderState {
  final String error;

  const OrderError({required this.error});

  @override
  List<Object> get props => [error];
}

class OrderLoaded extends OrderState {
  final List<OrderList> orders;

  const OrderLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class CartLoaded extends OrderState {
  final OrderList cartItems;
  final List<OrderItem> outOfStockItems;

  const CartLoaded({
    required this.cartItems,
    required this.outOfStockItems,
  });
}


class OrderSubmitted extends OrderState {}
class LogoutSuccess extends OrderState {}