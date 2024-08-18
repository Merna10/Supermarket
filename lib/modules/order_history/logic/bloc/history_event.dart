part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchUserOrders extends HistoryEvent {
  final String userId;
  final String status;

  const FetchUserOrders({required this.userId, this.status = 'All'});

  @override
  List<Object> get props => [userId, status];
}

class FetchOrders extends HistoryEvent {
  final String status;

  const FetchOrders({this.status = 'All'});

  @override
  List<Object> get props => [status];
}

class HistoryLoaded extends HistoryEvent {
  final List<OrderList> orders;

  const HistoryLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class HistoryError extends HistoryEvent {
  final String error;

  const HistoryError({required this.error});

  @override
  List<Object> get props => [error];
}

class UpdateOrderStatus extends HistoryEvent {
  final String orderId;
  final String newStatus;

  UpdateOrderStatus({required this.orderId, required this.newStatus});

  @override
  List<Object> get props => [orderId, newStatus];
}