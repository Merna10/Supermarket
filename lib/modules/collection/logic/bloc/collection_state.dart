part of 'collection_bloc.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object?> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoadedState extends CollectionState {
  final List<Collection> collections;

  const CollectionLoadedState({required this.collections});

  @override
  List<Object?> get props => [collections];
}

class CollectionNameLoaded extends CollectionState {
  final String collectionName;

  const CollectionNameLoaded({required this.collectionName});

  @override
  List<Object> get props => [collectionName];
}



class CollectionErrorState extends CollectionState {
  final String error;

  const CollectionErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

