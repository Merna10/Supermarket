import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/review/data/model/review.dart';
import 'package:market/modules/review/data/repositories/review_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc(this._reviewRepository) : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
    on<FetchReviewsEvent>(_onFetchReviews);
  }

  Future<void> _onAddReview(
      AddReviewEvent event, Emitter<ReviewState> emit) async {
    try {
      print('Adding review');
      await _reviewRepository.addReview(event.review);

      emit(ReviewAdded());
      add(FetchReviewsEvent());
      print('Review added');
    } catch (e) {
      emit(ReviewError(e.toString()));
      print('Error adding review: ${e.toString()}');
    }
  }

  Future<void> _onFetchReviews(
      FetchReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewsLoading());
    print('Fetching reviews');
    await _reviewRepository.getReviews().listen((reviews) {
      print('Reviews fetched: ${reviews.length}');
      emit(ReviewsLoaded(reviews));
    }, onError: (e) {
      emit(ReviewError(e.toString()));
      print('Error fetching reviews: ${e.toString()}');
    }).asFuture();
  }
}
