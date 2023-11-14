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
  :  = doc.id,
    userRole = doc.data()!['userRole'],
    firstName = doc.data()!['firstName'],
    lastName = doc.data()!['lastName'],
    middleName = doc.data()!['middleName'],
    suffix = doc.data()!['suffix'],
    dob = doc.data()!['dob'],
    sex = doc.data()!['sex'],
    streetAddress = doc.data()!['streetAddress'],
    city = doc.data()!['city'],
    state = doc.data()!['state'],
    zipCode = doc.data()!['zipCode'],
    emailAdd = doc.data()!['emailAdd'],
    username = doc.data()!['username'],
    phoneNumber = doc.data()!['phoneNumber'],
    status = doc.data()!['status'],
    validId = doc.data()!['validId'],
    idProof = doc.data()!['idProof'],
    profilePic = doc.data()!['profilePic'],
    createdAt = doc.data()!['createdAt'];


  final String? reviewId;
  final double rating;
  final String comment;
  final DateTime? createdAt;
  final String userId;
  final String requestId;

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'rating': rating,
      'comment': comment,
      'createdAt': DateTime.now(),
      'userId': userId,
      'requestId': requestId,
    };
  }
}
