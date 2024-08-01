import 'package:market/modules/review/data/model/review.dart';
import 'package:market/modules/review/data/services/review_service.dart';

class ReviewRepository {
  final ReviewService _reviewService;

  ReviewRepository(this._reviewService);

  Future<void> addReview(Review review) async {
    await _reviewService.addReview(review);
  }

  Stream<List<Review>> getReviews() {
    return _reviewService.getReviews();
  }
}
