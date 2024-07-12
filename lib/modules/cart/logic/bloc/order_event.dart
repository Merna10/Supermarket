// lib/bloc/order_event.dart
part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddOrderItem extends OrderEvent {
  final OrderItem orderItem;
  final String userId;

  const AddOrderItem({required this.orderItem, required this.userId});

  @override
  List<Object> get props => [orderItem, userId];
}

class SubmitOrder extends OrderEvent {
  final String userId;

  const SubmitOrder({required this.userId});

  @override
  List<Object> get props => [userId];
}

class FetchOrders extends OrderEvent {
  final String userId;

  const FetchOrders({required this.userId});

  @override
  List<Object> get props => [userId];
}
