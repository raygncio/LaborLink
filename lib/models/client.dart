import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
//import 'package:firebase_auth/firebase_auth.dart';

final formatter = DateFormat.yMd();
// final authenticatedUser = FirebaseAuth.instance.currentUser!;

class Client {
  // PROPERTIES
  final String? userId;
  final String userRole;
  final String firstName;
  final String lastName;
  final String middleName;
  final String? suffix;
  final DateTime? dob;
  final String sex;
  final String streetAddress;
  final String city;
  final String state;
  final int zipCode;
  final String emailAdd;
  final String username;
  final String phoneNumber;
  final String? status;
  final String validId; // file attachment url
  final String idProof; // file attachment url
  final String? profilePic; // file attachment url
  final DateTime? createdAt;

  // CONSTRUCTORS
  Client({
    required this.userId,
    required this.userRole,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    this.suffix,
    this.dob,
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
    this.profilePic,
    this.createdAt,
  });

  factory Client.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    //SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Client(
      userId: snapshot.id, //
      userRole: data?['userRole'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      middleName: data?['middleName'],
      suffix: data?['suffix'],
      dob: (data?['dob'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sex: data?['sex'],
      streetAddress: data?['streetAddress'],
      city: data?['city'],
      state: data?['state'],
      zipCode: data?['zipCode'],
      emailAdd: data?['emailAdd'],
      username: data?['username'],
      phoneNumber: data?['phoneNumber'],
      status: data?['status'],
      validId: data?['validId'],
      idProof: data?['idProof'],
      profilePic: data?['profilePic'],
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userRole': userRole,
      'firstName': firstName.toLowerCase(),
      'lastName': lastName.toLowerCase(),
      'middleName': middleName,
      'suffix': suffix,
      'dob': dob,
      'sex': sex,
      'streetAddress': streetAddress,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'emailAdd': emailAdd,
      'username': username,
      'phoneNumber': phoneNumber,
      'status': userRole == 'handyman' ? 'pending' : 'active',
      'validId': validId,
      'idProof': idProof,
      'profilePic': profilePic,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  // String get formattedDob {
  //   return formatter.format(dob);
  // }
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
