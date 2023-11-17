import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/models/handyman_approval.dart';
import 'package:laborlink/models/offer.dart';
import 'package:laborlink/models/report.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/models/review.dart';

class DatabaseService {
  // INITIALIZE

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // PATHS

  final nbiClearanceStorage =
      FirebaseStorage.instance.ref().child('nbi_clearance');

  // UPLOAD FILES
  // For nbi clearance
  Future<String> uploadNBIClearance(String userId, File selectedImage) async {
    final nbiStorage =
        _storage.ref().child('nbi_clearance').child('$userId.jpg');
    await nbiStorage.putFile(selectedImage);
    final imageUrl = await nbiStorage.getDownloadURL();

    return imageUrl;
  }

  // For recommendation letter
  Future<String> uploadRecommendationLetter(
      String userId, File selectedImage) async {
    final recommendationStorage =
        _storage.ref().child('recommendation_letter').child('$userId.jpg');
    await recommendationStorage.putFile(selectedImage);
    final imageUrl = await recommendationStorage.getDownloadURL();

    return imageUrl;
  }

  // For valid id
  Future<String> uploadValidId(String userId, File selectedImage) async {
    final idStorage = _storage.ref().child('valid_id').child('$userId.jpg');
    await idStorage.putFile(selectedImage);
    final imageUrl = await idStorage.getDownloadURL();

    return imageUrl;
  }

  // For proof of certification
  Future<String> uploadTesda(String userId, File selectedImage) async {
    final certStorage =
        _storage.ref().child('certification').child('$userId.jpg');
    await certStorage.putFile(selectedImage);
    final imageUrl = await certStorage.getDownloadURL();

    return imageUrl;
  }

  // USERS

  addUser(Client userData) async {
    await _db.collection('user').add(userData.toFirestore());
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('user').doc(userId).get();

    if (snapshot.exists) {
      // Convert the snapshot data to a Map
      Map<String, dynamic> userData = snapshot.data()!;

      return userData;
    } else {
      // If the document doesn't exist, return null or an empty Map
      return {};
    }
  }

  // HANDYMAN

  addHandyman(Handyman handymanData) async {
    await _db.collection('handyman').add(handymanData.toFirestore());
  }

  Future<Handyman> getHandymanData(String userId) async {
    final querySnap = await _db
        .collection('handyman')
        .where('userId', isEqualTo: userId)
        .get();
    return Handyman.fromFireStore(querySnap.docs.single);
  }

  // alt code wahawhahwhaw
  // Future<Handyman> getHandymanData(String userId) async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //       await _db.collection('handyman').get();

  //   // every doc in list will be filtered
  //   // returns the doc if the condition is met
  //   return snapshot.docs
  //       .map((docSnapshot) => Handyman.fromDocumentSnapshot(
  //           docSnapshot)) // maps every querysnapshot  into an iterable list and initialzes each handyman
  //       .firstWhere((handyman) =>
  //           handyman.userId ==
  //           userId); // finds the first handyman in the list that meets the condition
  // }

  // REQUEST

  addRequest(Request requestData) async {
    await _db.collection('handyman').add(requestData.toMap());
  }

  // COMPOUND QUERIES USING FILTER.OR(FILTER()), FILTER.AND(FILTER())
  Future<Request> getRequestData(String userId) async {
    final querySnap = await _db
        .collection('request')
        .where(
          Filter.and(
            Filter(
              Filter.or(
                // userId input can be user or handyman's
                Filter('userId', isEqualTo: userId),
                Filter('handymanId', isEqualTo: userId),
              ),
            ),
            Filter.or(
              Filter('progress', isEqualTo: 'pending'),
              Filter('progress', isEqualTo: 'inprogress'),
            ),
          ),
        )
        .get();
    return Request.fromFireStore(
        querySnap.docs.single); // expects 1 doc in the query
  }

  Future<List<Request>> getRequestHistory(String userId) async {
    final querySnap = await _db
        .collection('request')
        .where(
          Filter.or(
            // userId input can be user or handyman's
            Filter('userId', isEqualTo: userId),
            Filter('handymanId', isEqualTo: userId),
          ),
        )
        .get();
    return querySnap.docs // many docs in the query
        .map(
          //for each
          (docSnap) => Request.fromFireStore(docSnap),
        )
        .toList(); // makes iterable list to list
  }

  // HANDYMAN_APPROVAL

  // addHandyman(Request handymanData) async {
  //   await _db.collection('handyman').add(handymanData.toMap());
  // }

  // Future<Handyman> getHandymanData(String userId) async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //       await _db.collection('handyman').get();

  //   // every doc in list will be filtered
  //   // returns the doc if the condition is met
  //   return snapshot.docs
  //       .map((docSnapshot) => Handyman.fromDocumentSnapshot(
  //           docSnapshot)) // maps every querysnapshot  into an iterable list and initialzes each handyman
  //       .firstWhere((handyman) =>
  //           handyman.userId ==
  //           userId); // finds the first handyman that met the condition in the list of handyman
  // }

  // OFFERS

  // REVIEWS

  // REPORTS

  // ADMIN

  Future<List<Client>> retrieveAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('user').get(); //gets the snapshot

    return snapshot.docs // access docs found in the snapshot
        .map((docSnapshot) => Client.fromFireStore(
            docSnapshot)) // maps every doc, initializes a Client class,
        .toList(); // and transforms each map into list
  }

  // Future<List<Handyman>> retrieveAllHandymen() async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //       await _db.collection('handyman').get();
  //   return snapshot.docs
  //       .map((docSnapshot) => Handyman.fromFirestore(docSnapshot))
  //       .toList();
  // }
}
