import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Report {
  Report(
      {this.reportId,
      required this.issue,
      required this.proof,
      required this.userId,
      required this.createdAt});

  final String? reportId;
  final String issue;
  final String proof;
  final DateTime createdAt;
  final String userId;

  //methods

  Map<String, dynamic> toMap() {
    return {
      'requestId': reportId,
      'title': issue,
      'category': proof,
      'description': createdAt,
      'attachment': userId
    };
  }
}
