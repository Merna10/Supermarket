import 'dart:io';

import 'package:market/modules/collection/data/models/collection.dart';
import 'package:market/modules/collection/data/services/collection_service.dart';

class CollectionRepository {
  final CollectionService _collectionService;

  CollectionRepository({CollectionService? collectionService})
      : _collectionService = collectionService ?? CollectionService();

  Stream<List<Collection>> fetchCollections() {
    return _collectionService.fetchCollections();
  }

  Future<void> addCollection(Collection collection,File? imageFile) async {
    try {
      return _collectionService.addCollection(collection,imageFile);
    } catch (e) {
      print('Failed to add Collection: $e');
      throw Exception('Failed to add collections: $e');
    }
  }

   Future<String> fetchCollectionName(String collectionID) async {
    try {
      return _collectionService.fetchCollectionName(collectionID);
    } catch (e) {
      print('Failed to get Collection: $e');
      throw Exception('Failed to get Collections: $e');
    }
  }

  Future<void> deleteCollection(Collection collection) async {
    try {
      return _collectionService.deleteCollection(collection);
    } catch (e) {
      print('Failed to add Collection: $e');
      throw Exception('Failed to add collections: $e');
    }
  }
}
