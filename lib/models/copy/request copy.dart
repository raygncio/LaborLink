import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class Request {
  Request(
      {this.requestId,
      required this.title,
      required this.category,
      required this.description,
      required this.attachment,
      required this.address,
      required this.dateTime,
      required this.progress,
      required this.suggestedPrice,
      this.completionProof,
      this.createdAt,
      required this.userId,
      this.handymanId});

  // for getting all
  Request.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : requestId = doc.id,
        title = doc.data()!['title'],
        category = doc.data()!['category'],
        description = doc.data()!['description'],
        attachment = doc.data()!['attachment'],
        address = doc.data()!['address'],
        dateTime = doc.data()!['dateTime'],
        progress = doc.data()!['progress'],
        suggestedPrice = doc.data()!['suggestedPrice'],
        completionProof = doc.data()!['completionProof'],
        createdAt = doc.data()!['createdAt'],
        userId = doc.data()!['userId'],
        handymanId = doc.data()!['handymanId'];

  final String? requestId;
  final String title;
  final Specialization category;
  final String description;
  final File attachment; // file attachment
  final String address;
  final DateTime dateTime;
  final String progress;
  final double suggestedPrice;
  final File? completionProof; // file attachment
  final DateTime? createdAt;
  final String userId;
  final String? handymanId;

  //methods

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'attachment': attachment,
      'address': address,
      'dateTime': dateTime,
      'progress': progress,
      'suggestedPrice': suggestedPrice,
      'completionProof': completionProof,
      'createdAt': createdAt ?? DateTime.now(),
      'userId': userId,
      'handymanId': handymanId,
    };
  }
}
