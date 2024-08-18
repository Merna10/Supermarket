part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoadedList extends HistoryState {
  final List<OrderList> orders;

  const HistoryLoadedList({required this.orders});

  @override
  List<Object> get props => [orders];
}

class HistoryErrors extends HistoryState {
  final String error;

  const HistoryErrors({required this.error});

  @override
  List<Object> get props => [error];
}

class StatusUpdateSuccess extends HistoryState {}