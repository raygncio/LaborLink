import 'package:intl/intl.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final formatter = DateFormat.yMd();
final authenticatedUser = FirebaseAuth.instance.currentUser!;

class User {
  // CONSTRUCTORS

  User({
    this.userId,
    required this.userRole,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.suffix,
    required this.dob,
    required this.sex,
    required this.streetAddress,
    required this.state,
    required this.city,
    required this.zipCode,
    required this.emailAdd,
    required this.username,
    required this.phoneNumber,
    this.status,
    required this.validId,
    required this.idProof,
    required this.profilePic,
    this.createdAt,
  });

  // for getting all
  User.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : userId = doc.id,
        userRole = doc.data()!['userRole'],
        firstName = doc.data()!['firstName'],
        lastName = doc.data()!['lastName'],
        middleName = doc.data()!['middleName'],
        suffix = doc.data()!['suffix'],
        dob = doc.data()!['dob'],
        sex = doc.data()!['sex'],
        streetAddress = doc.data()!['streetAddress'],
        city = doc.data()!['city'],
        state = doc.data()!['state'],
        zipCode = doc.data()!['zipCode'],
        emailAdd = doc.data()!['emailAdd'],
        username = doc.data()!['username'],
        phoneNumber = doc.data()!['phoneNumber'],
        status = doc.data()!['status'],
        validId = doc.data()!['validId'],
        idProof = doc.data()!['idProof'],
        profilePic = doc.data()!['profilePic'],
        createdAt = doc.data()!['createdAt'];

  // PROPERTIES

  final String? userId;
  final String userRole;
  final String firstName;
  final String lastName;
  final String middleName;
  final String suffix;
  final DateTime dob;
  final String sex;
  final String streetAddress;
  final String city;
  final String state;
  final int zipCode;
  final String emailAdd;
  final String username;
  final String phoneNumber;
  final String? status;
  final File validId; // file attachment
  final File idProof; // file attachment
  final File profilePic;
  final DateTime? createdAt;

  // METHODS

  // for adding, updating, deleting
  Map<String, dynamic> toMap() {
    return {
      'userId': authenticatedUser.uid,
      'userRole': userRole,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'suffix': suffix,
      'dob': dob,
      'sex': sex,
      'streetAddress': streetAddress,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'emailAdd': authenticatedUser.email,
      'username': authenticatedUser.displayName,
      'phoneNumber': phoneNumber,
      'status': userRole == 'handyman' ? 'pending' : 'active',
      'validId': validId,
      'idProof': idProof,
      'createdAt': DateTime.now(),
    };
  }

  String get formattedDob {
    return formatter.format(dob);
  }
}

// HELPER CLASS

// class Address {
//   Address(
//       {required this.streetAddress,     
//       required this.city,
//       required this.state,
//       required this.zipCode});

//   Address.fromMap(Map<String, dynamic> addressMap)
//       : streetAddress = addressMap['streetAddress'],
//         city = addressMap['city']
//         state = addressMap['state'],
//         zipCode = addressMap['zipCode'];

//   final String streetAddress;
//   final String city;
//   final String state;
//   final int zipCode;

//   Map<String, dynamic> toMap() {
//     return {
//       'streetAddress': streetAddress,
//       'city': city
//       'state': state,
//       'cityName': zipCode,
//     };
//   }

// }