import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

enum Specialization {
  plumbing,
  carpentry,
  electrical,
  painting,
  maintenance,
  welding,
  housekeeping,
  roofing,
  installation,
  pestcontrol
}

class Handyman {
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
      required this.userId});

  // for getting all
  Handyman.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : handymanId = doc.id,
        applicantStatus = doc.data()!['applicantStatus'],
        specialization = doc.data()!['specialization'],
        employer = doc.data()!['employer'],
        nbiClearance = doc.data()!['nbiClearance'],
        certification = doc.data()!['certification'],
        certificationProof = doc.data()!['certificationProof'],
        recommendationLetter = doc.data()!['recommendationLetter'],
        createdAt = doc.data()!['createdAt'],
        userId = doc.data()!['userId'];

  final String? handymanId;
  final String applicantStatus;
  final Specialization specialization;
  final String employer;
  final File nbiClearance; // file attachment
  final String certification;
  final File certificationProof; // file attachment
  final File recommendationLetter; // file attachment
  final DateTime? createdAt;
  final String userId;

  //methods
  Map<String, dynamic> toMap() {
    return {
      'applicantStatus': applicantStatus,
      'specialization': specialization,
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
