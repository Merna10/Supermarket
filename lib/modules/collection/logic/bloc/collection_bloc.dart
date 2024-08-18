import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/collection/data/repositories/collection_repository.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository _collectionRepository;
  StreamSubscription<List<Collection>>? _collectionSubscription;

  CollectionBloc({required CollectionRepository collectionRepository})
      : _collectionRepository = collectionRepository,
        super(CollectionInitial()) {
    on<FetchCollections>(_onFetchCollections);
    on<CollectionLoaded>(_onCollectionLoaded);
    on<CollectionError>(_onCollectionError);
    on<AddCollectionItem>(_onAddCollection);
    on<RemoveCollectionItem>(_onDeleteCollection);
    on<FetchCollectionName>(_onFetchCollectionName);
  }

  void _onFetchCollections(FetchCollections event, Emitter<CollectionState> emit) {
    emit(CollectionLoading());
    _collectionSubscription?.cancel();

    try {
      _collectionSubscription = _collectionRepository.fetchCollections().listen(
        (collections) {
          add(CollectionLoaded(collections: collections));
        },
        onError: (error) {
          add(CollectionError(error: error.toString()));
        },
      );
    } catch (e) {
      add(CollectionError(error: e.toString()));
    }
  }

 void _onFetchCollectionName(
    FetchCollectionName event, Emitter<CollectionState> emit) async {
  emit(CollectionLoading());
  try {
    final collectionName = await _collectionRepository.fetchCollectionName(event.collectionId);
    emit(CollectionNameLoaded(collectionName: collectionName));
  } catch (e) {
    emit(CollectionErrorState(error: e.toString()));
  }
}  

 Future<void> _onAddCollection(AddCollectionItem event, Emitter<CollectionState> emit) async {
    emit(CollectionLoading());
    try {
      await _collectionRepository.addCollection(event.collection, event.imageFile);
      add(FetchCollections());
    } catch (e) {
      emit(CollectionErrorState(error: e.toString()));
    }
  }

   void _onDeleteCollection(
      RemoveCollectionItem event, Emitter<CollectionState> emit) async {
    emit(CollectionLoading());
    try {
      await _collectionRepository.deleteCollection(event.collection);
      add(FetchCollections());
    } catch (e) {
      emit(CollectionErrorState(error: e.toString()));
    }
  }

  void _onCollectionLoaded(CollectionLoaded event, Emitter<CollectionState> emit) {
    emit(CollectionLoadedState(collections: event.collections));
  }

  void _onCollectionError(CollectionError event, Emitter<CollectionState> emit) {
    emit(CollectionErrorState(error: event.error));
  }

  @override
  Future<void> close() {
    _collectionSubscription?.cancel();
    return super.close();
  }
}
