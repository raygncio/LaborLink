import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Report {
  Report(
      {this.reportId,
      required this.issue,
      required this.proof,
      this.createdAt,
      required this.userId});

  // for getting all
  Report.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : reportId = doc.id,
        issue = doc.data()!['issue'],
        proof = doc.data()!['proof'],
        createdAt = doc.data()!['createdAt'],
        userId = doc.data()!['userId'];

  final String? reportId;
  final String issue;
  final File proof;
  final DateTime? createdAt;
  final String userId;

  //methods

  Map<String, dynamic> toMap() {
    return {
      'issue': issue,
      'proof': proof,
      'createdAt': createdAt ?? DateTime.now(),
      'userId': userId
    };
  }
}
