import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/review/data/model/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _reviewsCollection = FirebaseFirestore.instance.collection('reviews');

  Future<void> addReview(Review review) async {
    print('Adding review: ${review.toMap()}');
    await _reviewsCollection.add(review.toMap());
    print('Review added');
  }

  Stream<List<Review>> getReviews() {
    print('Fetching reviews');
    return _reviewsCollection.snapshots().map((snapshot) {
      print('Received snapshot');
      return snapshot.docs.map((doc) {
        print('Processing doc: ${doc.data()}');
        return Review.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
