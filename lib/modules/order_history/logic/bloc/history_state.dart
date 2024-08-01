part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<OrderList> orders;

  const HistoryLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class HistoryError extends HistoryState {
  final String error;

  const HistoryError({required this.error});

  @override
  List<Object> get props => [error];
}
