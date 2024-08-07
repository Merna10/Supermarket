import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/collection/data/models/collection.dart';

class CollectionService {
  final FirebaseFirestore _firestore;

  CollectionService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Collection>> fetchCollections() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('collections').orderBy('dateAdded').get();
      return snapshot.docs.map((doc) => Collection.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
