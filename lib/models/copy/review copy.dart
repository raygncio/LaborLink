import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  Review({
    this.reviewId,
    required this.rating,
    required this.comment,
    this.createdAt,
    required this.userId,
    required this.requestId,
  });

  // for getting all
  Review.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : reviewId = doc.id,
        rating = doc.data()!['rating'],
        comment = doc.data()!['comment'],
        createdAt = doc.data()!['createdAt'],
        userId = doc.data()!['userId'],
        requestId = doc.data()!['requestId'];

  final String? reviewId;
  final double rating;
  final String comment;
  final DateTime? createdAt;
  final String userId;
  final String requestId;

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt ?? DateTime.now(),
      'userId': userId,
      'requestId': requestId,
    };
  }
}
