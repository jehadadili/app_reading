import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String userId;
  final String userName; // To display who made the comment
  final String bookId;
  final double rating;
  final String comment;
  final Timestamp timestamp;

  RatingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'bookId': bookId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RatingModel(
      id: documentId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      bookId: map['bookId'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}

