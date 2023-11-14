import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laborlink/lib/models/handyman.dart';
import 'dart:io';

final formatter = DateFormat.yMd();

class Request {
  Request({
    this.requestId,
    required this.title,
    required this.category,
    required this.description,
    required this.attachment,
    required this.address,
    required this.dateTime,
    required this.progress,
  }) : createdAt = DateTime.now();

  final String? requestId;
  final String title;
  final Specialization category;
  final String description;
  final File attachment; // file attachment
  final String address;
  final DateTime dateTime;
  final String progress;
  final DateTime createdAt;

  //methods

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'title': title,
      'category': category,
      'description': description,
      'attachment': attachment,
      'address': address,
      'dateTime': dateTime,
      'progress': progress,
      'createdAt': createdAt
    };
  }
}
