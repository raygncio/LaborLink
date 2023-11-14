import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
import 'dart:io';

// final formatter = DateFormat.yMd();
const uuid = Uuid();

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
  Handyman({
    this.applicantId,
    required this.applicantStatus,
    required this.specialization,
    required this.recommendation,
    required this.employer,
    required this.nbiClearance,
    required this.certification,
    required this.certificationProof,
    required this.userId,
  }) : createdAt = DateTime.now();

  final String? applicantId;
  final String applicantStatus;
  final Specialization specialization;
  final String recommendation;
  final String employer;
  final File nbiClearance; // file attachment
  final String certification;
  final File certificationProof; // file attachment
  final DateTime createdAt;
  final String userId;

  //methods
  Map<String, dynamic> toMap() {
    return {
      'applicantId': applicantId,
      'applicantStatus': applicantStatus,
      'specialization': specialization,
      'recommendation': recommendation,
      'employer': employer,
      'nbiClearance': nbiClearance,
      'certification': certification,
      'certificationProof': certificationProof,
      'createdAt': createdAt,
      'userId': userId
    };
  }
}
