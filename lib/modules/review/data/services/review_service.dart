import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/review/data/model/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _reviewsCollection = FirebaseFirestore.instance.collection('reviews');

  Future<void> addReview(Review review) async {
    await _reviewsCollection.add(review.toMap());
  }

  Stream<List<Review>> getReviews() {
    return _reviewsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
