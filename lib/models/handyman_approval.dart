import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

class HandymanAproval {
  HandymanAproval({
    this.approvalId,
    required this.status,
    required this.userId,
    required this.requestId,
  });

  final String? approvalId;
  final String status;
  final String userId;
  final String requestId;

  //methods
  Map<String, dynamic> toMap() {
    return {
      'applicantId': approvalId,
      'applicantStatus': status,
      'specialization': userId,
      'recommendation': requestId
    };
  }
}
