
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/collection/data/services/collection_service.dart';

class CollectionRepository {
  final CollectionService _collectionService;

  CollectionRepository({CollectionService? collectionService})
      : _collectionService = collectionService ?? CollectionService();

  Future<List<Collection>> fetchCollections() {
    return _collectionService.fetchCollections();
  }
}
