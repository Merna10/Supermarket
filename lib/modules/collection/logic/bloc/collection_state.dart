part of 'collection_bloc.dart';

sealed class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

final class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<Collection> collections;
  const CollectionLoaded({required this.collections});
  @override
  List<Object> get props => [collections];
}

class CollectionError extends CollectionState {
   final String error;
  const CollectionError({required this.error});
  @override
  List<Object> get props => [error];
}
