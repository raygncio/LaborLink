import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

class Offer {
  Offer({
    required this.suggestedFee,
    required this.status,
    required this.userId,
    required this.requestId,
  }) : offerId = uuid.v4();

  final String offerId;
  final double suggestedFee;
  final String status;
  final String userId;
  final String requestId;

  //methods
  Map<String, dynamic> toMap() {
    return {
      'offerId': offerId,
      'suggestedFee': suggestedFee,
      'status': status,
      'userId': userId,
      'requestId': requestId
    };
  }
}
