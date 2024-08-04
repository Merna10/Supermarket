part of 'order_bloc.dart';


abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends OrderEvent {
  
}

class AddOrderItem extends OrderEvent {
  final OrderItem orderItem;

  const AddOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}

class RemoveOrderItem extends OrderEvent {
  final OrderItem orderItem;

  const RemoveOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}

class UpdateOrderItemQuantity extends OrderEvent {
  final OrderItem orderItem;
  final int quantity;

  const UpdateOrderItemQuantity(
      {required this.orderItem, required this.quantity});

  @override
  List<Object> get props => [orderItem, quantity];
}

class SubmitOrder extends OrderEvent {
  final String userId;
  final String deliveryAddress;
  final double deliveryFees;
  const SubmitOrder({
    required this.userId,
    required this.deliveryAddress,
    required this.deliveryFees,
  });

  @override
  List<Object> get props => [userId];
}

class FetchOrders extends OrderEvent {
  final String userId;

  const FetchOrders({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadOrdersOnAppStart extends OrderEvent {
  final String userId;

  const LoadOrdersOnAppStart({required this.userId});

  @override
  List<Object> get props => [userId];
}
class Logout extends OrderEvent {
  final String userId;

  Logout({required this.userId});

  @override
  List<Object> get props => [userId];
}