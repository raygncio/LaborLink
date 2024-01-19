import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Handyman {
  // PROPERTIES
  final String? handymanId;
  final String applicantStatus;
  final String specialization;
  final String employer;
  final String nbiClearance; // file attachment
  final String certification;
  final String certificationProof; // file attachment
  final String recommendationLetter; // file attachment
  final DateTime? createdAt;
  final String? userId;

  // CONSTRUCTORS
  Handyman(
      {this.handymanId,
      required this.applicantStatus,
      required this.specialization,
      required this.employer,
      required this.nbiClearance,
      required this.certification,
      required this.certificationProof,
      required this.recommendationLetter,
      this.createdAt,
      this.userId});

  factory Handyman.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    //SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Handyman(
      handymanId: snapshot.id,
      applicantStatus: data?['applicantStatus'],
      specialization: data?['specialization'],
      employer: data?['employer'],
      nbiClearance: data?['nbiClearance'],
      certification: data?['certification'],
      certificationProof: data?['certificationProof'],
      recommendationLetter: data?['recommendationLetter'],
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'],
    );
  }

  // METHODS
  Map<String, dynamic> toFirestore() {
    return {
      // handymanId auto generated by fb
      'applicantStatus': applicantStatus,
      'specialization': specialization.toLowerCase(),
      'employer': employer,
      'nbiClearance': nbiClearance,
      'certification': certification,
      'certificationProof': certificationProof,
      'recommendationLetter': recommendationLetter,
      'createdAt': createdAt ?? DateTime.now(),
      'userId': userId
    };
  }
}
