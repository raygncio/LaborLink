import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Offer {
  Offer({
    this.offerId,
    required this.bidPrice,
    required this.status,
    required this.description,
    required this.attachment,
    required this.userId,
    required this.requestId,
  });
  // for getting all
  Offer.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : offerId = doc.id,
        bidPrice = doc.data()!['bidPrice'],
        status = doc.data()!['status'],
        description = doc.data()!['description'],
        attachment = doc.data()!['attachment'],
        userId = doc.data()!['userId'],
        requestId = doc.data()!['requestId'];

  final String? offerId;
  final double bidPrice;
  final String status;
  final String description;
  final File attachment;
  final String userId;
  final String requestId;

  //methods
  Map<String, dynamic> toMap() {
    return {
      'bidPrice': bidPrice,
      'status': status,
      'description': description,
      'attachment': attachment,
      'userId': userId,
      'requestId': requestId
    };
  }
}
