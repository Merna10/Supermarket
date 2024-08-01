import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review extends Equatable {
  final String commenterName;
  final DateTime date;
  final String commentText;

  const Review({
    required this.commenterName,
    required this.date,
    required this.commentText,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      commenterName: map['commenterName'] as String,
      date: (map['date'] as Timestamp).toDate(),
      commentText: map['commentText'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commenterName': commenterName,
      'date': Timestamp.fromDate(date),
      'commentText': commentText,
    };
  }

  @override
  List<Object> get props => [commenterName, date, commentText];
}
