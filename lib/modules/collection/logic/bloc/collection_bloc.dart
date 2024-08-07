import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/collection/data/repositories/collection_repository.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository _collectionRepository;

  CollectionBloc({required CollectionRepository collectionRepository})
      : _collectionRepository = collectionRepository, super(CollectionInitial()) {
    on<FetchCollections>(_onFetchCollections);
  }

  void _onFetchCollections(FetchCollections event, Emitter<CollectionState> emit) async {
    emit(CollectionLoading());
    try {
      final collections = await _collectionRepository.fetchCollections();
      emit(CollectionLoaded(collections: collections));
    } catch (e) {
      emit(CollectionError(error: e.toString()));
    }
  }
}
