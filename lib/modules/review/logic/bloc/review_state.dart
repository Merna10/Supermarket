// review_state.dart
part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewAdded extends ReviewState {}

class ReviewsLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;

  const ReviewsLoaded(this.reviews);

  @override
  List<Object> get props => [reviews];
}

class ReviewError extends ReviewState {
  final String error;

  const ReviewError(this.error);

  @override
  List<Object> get props => [error];
}
