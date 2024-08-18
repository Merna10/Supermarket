part of 'collection_bloc.dart';

abstract class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object?> get props => [];
}

class FetchCollections extends CollectionEvent {}

class CollectionLoaded extends CollectionEvent {
  final List<Collection> collections;

  const CollectionLoaded({required this.collections});

  @override
  List<Object?> get props => [collections];
}

class FetchCollectionName extends CollectionEvent {
  final String collectionId;

  const FetchCollectionName({required this.collectionId});

  @override
  List<Object> get props => [collectionId];
}


class CollectionError extends CollectionEvent {
  final String error;

  const CollectionError({required this.error});

  @override
  List<Object?> get props => [error];
}

class AddCollectionItem extends CollectionEvent {
  final Collection collection;
  final File? imageFile;

  const AddCollectionItem({required this.collection, this.imageFile});

  @override
  List<Object?> get props => [collection, imageFile];
}
class RemoveCollectionItem extends CollectionEvent {
  final Collection collection;

  const RemoveCollectionItem({required this.collection});

  @override
  List<Object> get props => [collection];
}
