import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market/modules/collection/data/models/collection.dart';
import 'package:uuid/uuid.dart';

class CollectionService {
  final FirebaseFirestore _firestore;

  CollectionService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Collection>> fetchCollections() {
    try {
      return _firestore
          .collection('collections')
          .orderBy('dateAdded', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Collection.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addCollection(Collection collection, File? imageFile) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('collections/${const Uuid().v4()}.jpg');

        await storageRef.putFile(imageFile);

        imageUrl = await storageRef.getDownloadURL();
      } else {
        imageUrl = null;
      }
      final newCollection = Collection(
        id: collection.id,
        name: collection.name,
        imageUrl: imageUrl ?? collection.imageUrl,
        dateAdded: collection.dateAdded,
        description: collection.description,
      );

      await FirebaseFirestore.instance
          .collection('collections')
          .doc(newCollection.id)
          .set(newCollection.toMap());
    } catch (e) {
      print('Failed to add Collection: $e');
      throw Exception('Failed to add collection: $e');
    }
  }

  Future<String> fetchCollectionName(String collectionID) async {
  try {
    final docSnapshot = await _firestore.collection('collections').doc(collectionID).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return data?['name'] ?? 'Unknown Collection'; 
    } else {
      throw Exception('Collection not found');
    }
  } catch (e) {
    print('Failed to get Collection: $e');
    throw Exception('Failed to get Collection: $e');
  }
}

  Future<void> deleteCollection(Collection collection) async {
    try {
      await _firestore.collection('collections').doc(collection.id).delete();
    } catch (e) {
      print('Failed to add Collection: $e');
      throw Exception('Failed to add collections: $e');
    }
  }
}
