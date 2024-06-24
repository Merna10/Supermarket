import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/home/data/models/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> fetchCategories() async {
    List<Category> categories = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('categories').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        categories.add(Category.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print(e);
    }

    return categories;
  }
}
