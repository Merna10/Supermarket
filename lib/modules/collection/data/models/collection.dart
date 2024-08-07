import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime dateAdded;

  Collection({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.dateAdded, 
  });

  factory Collection.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Collection(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      dateAdded: (data['dateAdded'] as Timestamp).toDate(), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'dateAdded': Timestamp.fromDate(dateAdded), 
    };
  }
}
