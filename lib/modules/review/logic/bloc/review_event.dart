// review_event.dart
part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class AddReviewEvent extends ReviewEvent {
  final Review review;

  const AddReviewEvent(this.review);

  @override
  List<Object> get props => [review];
}

class FetchReviewsEvent extends ReviewEvent {}
