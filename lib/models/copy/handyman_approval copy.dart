import 'package:cloud_firestore/cloud_firestore.dart';

class HandymanAproval {
  HandymanAproval({
    this.approvalId,
    required this.status,
    required this.handymanId,
    required this.requestId,
  });

  // for getting all
  HandymanAproval.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : approvalId = doc.id,
        status = doc.data()!['status'],
        handymanId = doc.data()!['handymanId'],
        requestId = doc.data()!['requestId'];

  final String? approvalId;
  final String status;
  final String handymanId;
  final String requestId;

  //methods
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'handymanId': handymanId,
      'requestId': requestId,
    };
  }
}
