import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/models/handyman_approval.dart';
import 'package:laborlink/models/offer.dart';
import 'package:laborlink/models/report.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/models/review.dart';
import 'package:laborlink/services/analytics_service.dart';

class DatabaseService {
  // INITIALIZE

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AnalyticsService _analytics = AnalyticsService();

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

  // For request attachments
  Future<String> uploadRequestAttachment(
      String userId, File selectedImage) async {
    String filename = '$userId-${DateTime.now()}';
    final requestStorage =
        _storage.ref().child('request').child('$filename.jpg');
    await requestStorage.putFile(selectedImage);
    final imageUrl = await requestStorage.getDownloadURL();

    return imageUrl;
  }

  // For offer attachments
  Future<String> uploadOfferAttachment(
      String userId, File selectedImage) async {
    String filename = '$userId-${DateTime.now()}';
    final offerStorage = _storage.ref().child('offer').child('$filename.jpg');
    await offerStorage.putFile(selectedImage);
    final imageUrl = await offerStorage.getDownloadURL();

    return imageUrl;
  }

  // For report attachments
  Future<String> uploadReportAttachment(
      String userId, File selectedImage) async {
    String filename = '$userId-${DateTime.now()}';
    final reportStorage = _storage.ref().child('report').child('$filename.jpg');
    await reportStorage.putFile(selectedImage);
    final imageUrl = await reportStorage.getDownloadURL();

    return imageUrl;
  }

  // For request attachments
  Future<String> uploadCompletionProof(
      String userId, File selectedImage) async {
    String filename = '$userId-${DateTime.now()}';
    final requestStorage =
        _storage.ref().child('request-completion').child('$filename.jpg');
    await requestStorage.putFile(selectedImage);
    final imageUrl = await requestStorage.getDownloadURL();

    return imageUrl;
  }

  // Face Verification Results [ADMIN]
  Future<String> uploadFace(String count, File selectedImage) async {
    String filename = 'faceResult-$count-${DateTime.now()}';
    final faceResultsStorage =
        _storage.ref().child('face-results').child('$filename.jpg');
    await faceResultsStorage.putFile(selectedImage);
    final imageUrl = await faceResultsStorage.getDownloadURL();

    return imageUrl;
  }

  // Anomaly Detection Results [ADMIN]
  Future<String> uploadId(String count, File selectedImage) async {
    String filename = 'anomalyResult-$count-${DateTime.now()}';
    final anomalyResultsStorage =
        _storage.ref().child('id-anomaly-results').child('$filename.jpg');
    await anomalyResultsStorage.putFile(selectedImage);
    final imageUrl = await anomalyResultsStorage.getDownloadURL();

    return imageUrl;
  }

  // ADMIN

  addFaceResult(FaceResults faceResults) async {
    await _db
        .collection('faceResults')
        .doc(faceResults.faceResultId)
        .set(faceResults.toFirestore());
  }

  addAnomalyResult(AnomalyResults anomalyResults) async {
    await _db
        .collection('anomalyResults')
        .doc(anomalyResults.anomalyResultId)
        .set(anomalyResults.toFirestore());
  }

  Future<List<FaceResults>> getAllFaceResults() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('faceResults')
        .orderBy("createdAt", descending: true)
        .get();

    List<FaceResults> faceResultsList = querySnapshot.docs.map((doc) {
      return FaceResults.fromFireStore(doc);
    }).toList();

    return faceResultsList;
  }

  Future<List<AnomalyResults>> getAllAnomalyResults() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('anomalyResults')
        .orderBy("createdAt", descending: true)
        .get();

    List<AnomalyResults> anomalyResultsList = querySnapshot.docs.map((doc) {
      return AnomalyResults.fromFireStore(doc);
    }).toList();

    return anomalyResultsList;
  }

  Future<List<Request>> getAllCompletedRequests() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('request')
        .where("progress", isEqualTo: "completed")
        .orderBy("createdAt", descending: true)
        .get();

    List<Request> completedRequestsList = querySnapshot.docs.map((doc) {
      return Request.fromFireStore(doc);
    }).toList();

    return completedRequestsList;
  }

  // USERS

  addUser(Client userData) async {
    await _db
        .collection('user')
        .doc(userData.userId)
        .set(userData.toFirestore());
  }

  Future<Client> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _db.collection('user').doc(userId).get();

    return Client.fromFireStore(docSnap);
  }

  // Search handyman and its data
  Future<List<Map<String, dynamic>>> getUserAndHandymanDataByFirstName(
      String searchText) async {
    List<Map<String, dynamic>> resultList = [];
    double rating = 0;
    double count = 0;
    double rates = 0;
    List<String> categoriesToCheck = [
      'plumbing',
      'installations',
      'carpentry',
      'electrical',
      'painting',
      'maintenance',
      'welding',
      'housekeeping',
      'roofing',
      'pest control',
    ];

    if (categoriesToCheck.contains(searchText.toLowerCase())) {
      // Query 'user' collection
      final userQuery = await _db.collection('user').get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userId = userDoc.id;

        // Query 'handyman' collection using userId
        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: userId)
            .where('specialization', isEqualTo: searchText)
            .get();

        // Process 'handyman' query results
        for (var handymanDoc in handymanQuery.docs) {
          final userData = userDoc.data();
          final handymanData = handymanDoc.data();
          final handymanId = handymanDoc.id;

          final reviewQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: userId)
              .get();
          for (var reviewDoc in reviewQuery.docs) {
            final reviewData = reviewDoc.data();
            rating += reviewData['rating'];
            count++;
          }
          rates = count > 0 ? rating / count : 0;
          // Combine user and handyman data into a single map
          Map<String, dynamic> combinedData = {
            ...userData,
            ...handymanData,
            'handymanId': handymanId,
            'rates': rates,
          };
          resultList.add(combinedData);
        }
      }
    } else {
      // Query 'user' collection
      final userQuery = await _db
          .collection('user')
          .where('firstName', isEqualTo: searchText)
          .get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userId = userDoc.id;

        // Query 'handyman' collection using userId
        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: userId)
            .get();

        // Process 'handyman' query results
        for (var handymanDoc in handymanQuery.docs) {
          final userData = userDoc.data();
          final handymanData = handymanDoc.data();
          final handymanId = handymanDoc.id;

          final reviewQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: userId)
              .get();
          for (var reviewDoc in reviewQuery.docs) {
            final reviewData = reviewDoc.data();
            rating += reviewData['rating'];
            count++;
          }
          rates = count > 0 ? rating / count : 0;
          // Combine user and handyman data into a single map
          Map<String, dynamic> combinedData = {
            ...userData,
            ...handymanData,
            'handymanId': handymanId,
            'rates': rates,
          };
          resultList.add(combinedData);
        }
      }
    }

    return resultList;
  }

  // HANDYMAN

  addHandyman(Handyman handymanData) async {
    await _db
        .collection('handyman')
        .doc(handymanData.handymanId)
        .set(handymanData.toFirestore());
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
    await _db
        .collection('request')
        .doc(requestData.requestId)
        .set(requestData.toMap());
  }

  // Get specific request
  Future<Request> getReqData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _db.collection('request').doc(userId).get();

    return Request.fromFireStore(docSnap);
  }

  // Get all the requests
  Future<List<Request>> getAllReqData(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _db.collection('request').get();

    List<Request> requestList = querySnapshot.docs.map((doc) {
      return Request.fromFireStore(doc);
    }).toList();

    return requestList;
  }

  // Search user and its request
  Future<List<Map<String, dynamic>>> getUserAndRequestBaseOnSearch(
      String searchText) async {
    List<Map<String, dynamic>> resultList = [];
    List<String> categoriesToCheck = [
      'plumbing',
      'installations',
      'carpentry',
      'electrical',
      'painting',
      'maintenance',
      'welding',
      'housekeeping',
      'roofing',
      'pest control',
    ];
    // Future.delayed(Duration(seconds: 1), () {
    //   print(searchText.toLowerCase());
    // });

    if (categoriesToCheck.contains(searchText.toLowerCase())) {
      // Query 'user' collection
      final userQuery = await _db.collection('user').get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userId = userDoc.id;

        // Query 'request' collection using userId
        final requestQuery = await _db
            .collection('request')
            .where('userId', isEqualTo: userId)
            .where('category', isEqualTo: searchText)
            .where('progress', isEqualTo: 'pending')
            .where('handymanId', isNull: true)
            .get();

        // Process 'request' query results
        for (var requestDoc in requestQuery.docs) {
          final userData = userDoc.data();
          final requestData = requestDoc.data();
          final requestId = requestDoc.id;

          // Combine user and request data into a single map
          Map<String, dynamic> combinedData = {
            ...userData,
            ...requestData,
            'requestId': requestId,
          };
          resultList.add(combinedData);
        }
      }
    } else {
      // Query 'user' collection
      final userQuery = await _db
          .collection('user')
          .where('firstName', isEqualTo: searchText)
          .get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userId = userDoc.id;

        // Query 'request' collection using userId
        final requestQuery = await _db
            .collection('request')
            .where('userId', isEqualTo: userId)
            .where('progress', isEqualTo: 'pending')
            .where('handymanId', isNull: true)
            .get();

        // Process 'request' query results
        for (var requestDoc in requestQuery.docs) {
          final userData = userDoc.data();
          final requestData = requestDoc.data();
          final requestId = requestDoc.id;

          // Combine user and request data into a single map
          Map<String, dynamic> combinedData = {
            ...userData,
            ...requestData,
            'requestId': requestId,
          };
          resultList.add(combinedData);
        }
      }
    }
    return resultList;
  }

  // Get all user and its request specific to the category of the handyman
  Future<List<Map<String, dynamic>>> getUserAndRequest(String userId) async {
    List<Map<String, dynamic>> resultList = [];
    DatabaseService service = DatabaseService();
    Handyman handyman = await service.getHandymanData(userId);

    // Query 'user' collection
    final userQuery = await _db.collection('user').get();

    // Process 'user' query results
    for (var userDoc in userQuery.docs) {
      final userId = userDoc.id;

      // Query 'request' collection using userId
      final requestQuery = await _db
          .collection('request')
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: handyman.specialization)
          .get();

      // Process 'request' query results
      for (var requestDoc in requestQuery.docs) {
        final userData = userDoc.data();
        final requestData = requestDoc.data();

        // Combine user and request data into a single map
        Map<String, dynamic> combinedData = {...userData, ...requestData};
        resultList.add(combinedData);
      }
    }
    return resultList;
  }

  // Get all completed request
  Future<List<Map<String, dynamic>>> getCompletedRequest(String userId) async {
    List<Map<String, dynamic>> resultList = [];
    double rating = 0;
    double count = 0;
    double rates = 0;
    // Query 'user' collection
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'completed')
        .get();

    // Process 'request' query results
    for (var requestDoc in requestQuery.docs) {
      final requestId = requestDoc.id;
      final requestData = requestDoc.data();
      final handymanId = requestData["handymanId"];
      final clientId = requestData["userId"];
      Map<String, dynamic> combinedData = {
        'clientId': clientId,
        'validRequestId': requestId,
        ...requestData,
      };

      // resultList.add(combinedData);

      final userQuery = await _db
          .collection('user')
          .where('userId', isEqualTo: handymanId)
          .where('userRole', isEqualTo: 'handyman')
          .get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();
        combinedData.addAll(userData);
        // print(handymanId);
        // Query 'review' using key from userData
        final reviewsQuery = await _db
            .collection('review')
            .where('userId', isEqualTo: handymanId)
            .get();
        // Process 'review' query results
        for (var reviewDoc in reviewsQuery.docs) {
          final reviewData = reviewDoc.data();
          rating += reviewData['rating'];
          count++;
          combinedData.addAll(reviewData);
        }
        rates = count > 0 ? rating / count : 0;
        combinedData.addAll({'rates': rates});
      }
      // print(combinedData);

      resultList.add(combinedData);
    }
    return resultList;
  }

  // Get all completed request
  Future<List<Map<String, dynamic>>> getCompletedRequestHandyman(
      String userId) async {
    List<Map<String, dynamic>> resultList = [];

    // Query 'user' collection
    final requestQuery = await _db
        .collection('request')
        .where('handymanId', isEqualTo: userId)
        .where('progress', isEqualTo: 'completed')
        .get();

    // Process 'request' query results
    for (var requestDoc in requestQuery.docs) {
      double rating = 0;
      double count = 0;
      double rates = 0;
      final requestId = requestDoc.id;
      final requestData = requestDoc.data();
      final handymanId = requestData["handymanId"];
      final clientId = requestData["userId"];
      Map<String, dynamic> combinedData = {
        'clientId': clientId,
        'validRequestId': requestId,
        ...requestData,
      };
      // resultList.add(combinedData);

      final userQuery = await _db
          .collection('user')
          .where('userId', isEqualTo: clientId)
          .where('userRole', isEqualTo: 'client')
          .get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();
        combinedData.addAll(userData);

        // Query 'review' using key from userData
        final reviewsQuery = await _db
            .collection('review')
            .where('userId', isEqualTo: handymanId)
            .get();
        // Process 'review' query results
        for (var reviewDoc in reviewsQuery.docs) {
          final reviewData = reviewDoc.data();
          rating += reviewData['rating'];
          count++;
          combinedData.addAll(reviewData);
        }
        rates = count > 0 ? rating / count : 0;
        combinedData.addAll({'rates': rates});
        print(rates);
      }
      resultList.add(combinedData);
    }
    return resultList;
  }

  // Get all cancelled request
  Future<List<Map<String, dynamic>>> getCancelledRequest(String userId) async {
    List<Map<String, dynamic>> resultList = [];
    // Query 'user' collection
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'cancelled')
        .get();

    // Process 'request' query results
    for (var requestDoc in requestQuery.docs) {
      final requestId = requestDoc.id;
      final requestData = requestDoc.data();
      Map<String, dynamic> combinedData = {
        'requestId': requestId,
        ...requestData,
      };
      resultList.add(combinedData);
    }
    return resultList;
  }

  // Get all cancelled request
  Future<List<Map<String, dynamic>>> getCancelledRequestHandyman(
      String userId) async {
    List<Map<String, dynamic>> resultList = [];

    final offerQuery = await _db
        .collection('offer')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'cancelled')
        .get();

    for (var offerDoc in offerQuery.docs) {
      final offerData = offerDoc.data();
      final price = offerData["bidPrice"];
      final requestId = offerData["requestId"];

      final requestDoc = await _db.collection('request').doc(requestId).get();

      // Process 'request' query results
      if (requestDoc.exists) {
        final requestData = requestDoc.data();
        Map<String, dynamic> combinedData = {
          'bidPrice': price,
          ...offerData,
          ...requestData!,
        };
        resultList.add(combinedData);
      }
    }

    final approvalQuery = await _db
        .collection('handymanApproval')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'cancelled')
        .get();

    for (var approvalDoc in approvalQuery.docs) {
      final approvalData = approvalDoc.data();
      // final price = offerData["bidPrice"];
      final requestId = approvalData["requestId"];

      final requestDoc = await _db.collection('request').doc(requestId).get();

      // Process 'request' query results
      if (requestDoc.exists) {
        final requestData = requestDoc.data();
        final price = requestData!["suggestedPrice"];
        Map<String, dynamic> combinedData = {
          'bidPrice': price,
          ...approvalData,
          ...requestData,
        };
        resultList.add(combinedData);
      }
    }

    return resultList;
  }

  // Get all the client history with handyman and reviews
  Future<Map<String, dynamic>> getClientHistory(
      String requestId, String userRole) async {
    Map<String, dynamic> resultMap = {};
    double rating = 0;
    double count = 0;
    double rates = 0;
    String checkId;
    final requestDoc = await _db.collection('request').doc(requestId).get();

    // Process 'request' query results
    if (requestDoc.exists) {
      final requestData = requestDoc.data();
      final handymanId = requestData!["handymanId"];
      final clientId = requestData["userId"];
      Map<String, dynamic> combinedData = {
        'requestId': requestId,
        'clientId': clientId,
        ...requestData,
      };

      if (userRole == 'client') {
        checkId = clientId;
      } else {
        checkId = handymanId;
      }

      // resultList.add(combinedData);
      final handymanQuery = await _db
          .collection('handyman')
          .where('userId', isEqualTo: handymanId)
          .get();

      for (var handyDoc in handymanQuery.docs) {
        final handyData = handyDoc.data();
        combinedData.addAll(handyData);
        final userQuery = await _db
            .collection('user')
            .where('userId', isEqualTo: checkId)
            .get();

        // Process 'user' query results
        for (var userDoc in userQuery.docs) {
          final userData = userDoc.data();
          combinedData.addAll(userData);
          print(">>>>>>>>>>>>>>>>>>>>$userData");
          // Query 'review' using key from userData
          final reviewsQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: handymanId)
              .get();
          // Process 'review' query results
          for (var reviewDoc in reviewsQuery.docs) {
            final reviewData = reviewDoc.data();
            rating += reviewData['rating'];
            count++;
            combinedData.addAll(reviewData);
          }
        }
        rates = count > 0 ? rating / count : 0;
        print('Ratse fs $rates');
        resultMap.addAll({'rates': rates});
      }

      resultMap.addAll(combinedData);
    }

    return resultMap;
  }

  // Get direct request of handyman
  Future<List<Map<String, dynamic>>> getDirectRequestOfHandyman(
      String handymanId) async {
    List<Map<String, dynamic>> resultList = [];

    final requestQuery = await _db
        .collection('request')
        .where('handymanId', isEqualTo: handymanId)
        .where('progress', isEqualTo: 'pending')
        .get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      final requestId = requestDoc.id;
      final userId = requestData['userId'];

      Map<String, dynamic> groupData = {
        ...requestData,
        'ActiveRequestId': requestId,
        'userId': userId,
        'handymanId': handymanId,
      };

      final userQuery = await _db
          .collection('user')
          .where('userId', isEqualTo: userId)
          .where('userRole', isEqualTo: 'client')
          .get();

      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();
        groupData.addAll(userData);

        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: handymanId)
            .get();
        for (var handymanDoc in handymanQuery.docs) {
          final handymanData = handymanDoc.data();
          groupData.addAll(handymanData);

          resultList.add(groupData);
        }
      }
    }
    return resultList;
  }

  // Get all the client history with handyman and reviews // kunin request, reviews
  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    Map<String, dynamic> resultMap = {};
    double rating = 0;
    double count = 0;
    double rates = 0;
    final userQuery =
        await _db.collection('user').where('userId', isEqualTo: userId).get();
    for (var userDoc in userQuery.docs) {
      final userData = userDoc.data();
      final userRole = userData['userRole'];

      resultMap.addAll(userData);
      final reviewQuery = await _db
          .collection('review')
          .where('userId', isEqualTo: userId)
          .get();
      for (var reviewDoc in reviewQuery.docs) {
        final reviewData = reviewDoc.data();
        rating += reviewData['rating'];
        count++;
        resultMap.addAll(reviewData);
      }

      if (userRole == 'handyman') {
        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: userId)
            .get();
        for (var handymanDoc in handymanQuery.docs) {
          final handymanData = handymanDoc.data();
          resultMap.addAll(handymanData);

          final reviewQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: userId)
              .get();
          for (var reviewDoc in reviewQuery.docs) {
            final reviewData = reviewDoc.data();
            rating += reviewData['rating'];
            count++;
            resultMap.addAll(reviewData);
          }
        }
      }
      rates = count > 0 ? rating / count : 0;

      resultMap.addAll({'rates': rates});
    }
    return resultMap;
  }

  Future<Request?> getRequestsData(String userId) async {
    final querySnap = await _db
        .collection('request')
        .where('progress', whereIn: [
          'pending',
          'hired',
          'omw',
          'arrived',
          'inprogress',
          'completion',
        ])
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnap.docs.isEmpty) {
      // Handle the case where no documents are found.
      // You might want to return null or throw an exception.
      return null;
    }

    // Assuming you expect only one document to match the conditions.
    return Request.fromFireStore(querySnap.docs.first);
  }

  Future<Request?> getHandymanService(String userId) async {
    final querySnap = await _db
        .collection('request')
        .where('progress', whereIn: [
          'hired',
          'omw',
          'arrived',
          'inprogress',
          'completion',
          'rating'
        ])
        .where('handymanId', isEqualTo: userId)
        .get();

    if (querySnap.docs.isEmpty) {
      // Handle the case where no documents are found.
      // You might want to return null or throw an exception.
      return null;
    }

    // Assuming you expect only one document to match the conditions.
    return Request.fromFireStore(querySnap.docs.first);
  }

  // CODE STILL NOT WORKING
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
        querySnap.docs.first); // expects 1 doc in the query
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

  // Update the progress to cancel request
  Future<void> userInfoUpdate(Map<String, dynamic> updatedData, String userId) async {
    final userQuery = await _db
        .collection('user')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in userQuery.docs) {
      String birthdateString = updatedData["birthdate"];
      DateTime birthdate = DateFormat('MMMM d, y').parse(birthdateString);
      String fullName = updatedData["fullName"];
      List<String> nameParts = fullName.split(' ');

      String firstName = '';
      String middleName = '';
      String lastName = '';
      String suffix = '';

      if (nameParts.length >= 4) {
        firstName = nameParts[0];
        middleName = nameParts[1];
        lastName = nameParts[2];
        suffix = nameParts[3];
      } else if (nameParts.length == 3) {
        firstName = nameParts[0];
        middleName = nameParts[1];
        lastName = nameParts[2];
      } else if (nameParts.length == 2) {
        firstName = nameParts[0];
        lastName = nameParts[1];
      } 

      await doc.reference.update({
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'suffix': suffix,
        'dob':Timestamp.fromDate(birthdate),
        'phoneNumber': updatedData["phoneNumber"],
      });
    }
  }

  // Update the progress to cancel request
  Future<void> cancelRequest(String userId) async {
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'pending')
        .get();

    for (var doc in requestQuery.docs) {
      await doc.reference.update({
        'progress': 'cancelled',
      });
    }
  }

  // Update the progress to cancel approval
  Future<void> cancelApproval(String userId) async {
    final approvalQuery = await _db
        .collection('handymanApproval')
        .where('handymanId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    for (var doc in approvalQuery.docs) {
      await doc.reference.update({
        'status': 'cancelled',
      });
    }

    final offerQuery = await _db
        .collection('offer')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    for (var doc in offerQuery.docs) {
      await doc.reference.update({
        'status': 'cancelled',
      });
    }
  }

  // Decline Direct Request
  Future<void> declineDirectRequest(String requestId) async {
    final requestDoc = await _db.collection('request').doc(requestId).get();

    if (requestDoc.exists) {
      await requestDoc.reference.update({'progress': 'cancelled'});
    }
  }

  // Update the handyman approval to hired
  Future<void> hiredHandyman(String handymanId, String requestId) async {
    final requestQuery = await _db
        .collection('handymanApproval')
        .where('handymanId', isEqualTo: handymanId)
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'pending')
        .get();

    for (var doc in requestQuery.docs) {
      await doc.reference.update({
        'status': 'hired',
      });
    }

    // check if there are other approval or offer and update the status to cancelled
    final approvalQuery = await _db
        .collection('handymanApproval')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (approvalQuery.docs.isNotEmpty) {
      for (var approvalDoc in approvalQuery.docs) {
        await approvalDoc.reference.update({
          'status': 'cancelled',
        });
      }
    }

    final offerQuery = await _db
        .collection('offer')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (offerQuery.docs.isNotEmpty) {
      for (var offerDoc in offerQuery.docs) {
        await offerDoc.reference.update({
          'status': 'cancelled',
        });
      }
    }
  }

  // Update the request to hired and assign the handyman selected
  Future<void> updateRequestProgress(
      String requestId, String handymanId) async {
    final requestDoc = await _db.collection('request').doc(requestId).get();

    if (requestDoc.exists) {
      await requestDoc.reference
          .update({'handymanId': handymanId, 'progress': 'hired'});
    }
  }

  // Update the request to hired and assign the handyman selected
  Future<void> updateRequestProgressWithOffer(
      String requestId, String handymanId, double bidPrice) async {
    final requestDoc = await _db.collection('request').doc(requestId).get();

    if (requestDoc.exists) {
      await requestDoc.reference.update({
        'handymanId': handymanId,
        'progress': 'hired',
        'suggestedPrice': bidPrice
      });
    }

    // check if there are other approval or offer and update the status to cancelled
    final approvalQuery = await _db
        .collection('handymanApproval')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (approvalQuery.docs.isNotEmpty) {
      for (var approvalDoc in approvalQuery.docs) {
        await approvalDoc.reference.update({
          'status': 'cancelled',
        });
      }
    }

    final offerQuery = await _db
        .collection('offer')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (offerQuery.docs.isNotEmpty) {
      for (var offerDoc in offerQuery.docs) {
        await offerDoc.reference.update({
          'status': 'cancelled',
        });
      }
    }
  }

  // Update the progress to cancelled request
  Future<void> updateRequest(String userId) async {
    String requestId = '';
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'completion')
        .get();

    for (var doc in requestQuery.docs) {
      requestId = doc.id;
      await doc.reference.update({
        'progress': 'rating',
      });
    }

    //check for handyman approval and offer if meron tapos completed ilagay
    final handymanQuery = await _db
        .collection('handymanApproval')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'hired')
        .get();

    if (handymanQuery.docs.isNotEmpty) {
      for (var doc in handymanQuery.docs) {
        await doc.reference.update({
          'status': 'rating',
        });
      }
    }

    final offerQuery = await _db
        .collection('offer')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'hired')
        .get();

    if (offerQuery.docs.isNotEmpty) {
      for (var doc in offerQuery.docs) {
        await doc.reference.update({
          'status': 'rating',
        });
      }
    }
  }

  // Update the request to hired and assign the handyman selected
  Future<void> updateRequestProgressHandyman(
      String requestId, int progress) async {
    print(">>>>>>>>>>>>>>> $progress");
    String update = " ";
    if (progress == 1) {
      update = "omw";
    } else if (progress == 2) {
      update = "arrived";
    } else if (progress == 3) {
      update = "inprogress";
    } else if (progress == 4) {
      update = "completion";
    } else if (progress == 5) {
      update = "completed";
    }

    await _db.collection("request").doc(requestId).update({
      'progress': update,
    });
  }

  // Update the offers to accepted
  Future<void> updateOffer(String handymanId) async {
    final requestQuery = await _db
        .collection('offer')
        .where('userId', isEqualTo: handymanId)
        .where('status', isEqualTo: 'pending')
        .get();

    for (var doc in requestQuery.docs) {
      await doc.reference.update({'status': 'hired'});
    }
  }

  // update the request for completion proof
  Future<void> updateRequestCompletion(String requestId, String url) async {
    final requestDoc = await _db.collection('request').doc(requestId).get();

    if (requestDoc.exists) {
      await requestDoc.reference
          .update({'completionProof': url, 'progress': 'completed'});
    }

    //check for handyman approval and offer if meron tapos completed ilagay
    final handymanQuery = await _db
        .collection('handymanApproval')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'rating')
        .get();

    if (handymanQuery.docs.isNotEmpty) {
      for (var doc in handymanQuery.docs) {
        await doc.reference.update({
          'status': 'completed',
        });
      }
    }

    final offerQuery = await _db
        .collection('offer')
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'rating')
        .get();

    if (offerQuery.docs.isNotEmpty) {
      for (var doc in offerQuery.docs) {
        await doc.reference.update({
          'status': 'completed',
        });
      }
    }
  }

  //get the document id tapos siya mag se serve as foreign key na
  // Update the request, handyman is interested with the request // handyman approval dapat itoooo
  // handymanId progress to waiting
  Future<void> handymanInterested(String handymanId, String requestId) async {
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: requestId)
        .get();

    for (var doc in requestQuery.docs) {
      await doc.reference.update({
        'handymanId': handymanId,
        'progress': 'waiting',
      });
    }
  }

  // HANDYMAN_APPROVAL

  addHandymanApproval(HandymanApproval approvalData) async {
    await _db.collection('handymanApproval').add(approvalData.toFirestore());
  }

  Future<List<Map<String, dynamic>>> getInterestedHandyman(
      String userId) async {
    List<Map<String, dynamic>> resultList = [];
    double rating = 0;
    double count = 0;
    double rates = 0;
    bool check = false;

    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'pending')
        .get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      final requestId = requestDoc.id;

      Map<String, dynamic> groupData = {
        ...requestData,
        'activeRequestId': requestId
      };

      final handymanQuery = await _db
          .collection('handymanApproval')
          .where('requestId', isEqualTo: requestId)
          .where('status', isEqualTo: 'pending')
          .get();

      // Process 'handyman approval' query results
      for (var handymanDoc in handymanQuery.docs) {
        final handymanData = handymanDoc.data();
        check = true;
        groupData.addAll(handymanData);
        final userID = handymanData['handymanId'];

        final checkHandymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: userID)
            .get();

        // Process 'user' query results
        for (var checkHandymanDoc in checkHandymanQuery.docs) {
          final checkHandymanData = checkHandymanDoc.data();
          groupData.addAll(checkHandymanData);

          final userQuery = await _db
              .collection('user')
              .where('userId', isEqualTo: userID)
              .get();

          // Process 'user' query results
          for (var userDoc in userQuery.docs) {
            final userData = userDoc.data();
            groupData.addAll(userData);

            // Query 'review' using key from userData
            final reviewsQuery = await _db
                .collection('review')
                .where('userId', isEqualTo: userID)
                .get();
            // Process 'review' query results
            for (var reviewDoc in reviewsQuery.docs) {
              final reviewData = reviewDoc.data();
              rating += reviewData['rating'];

              count++;
              groupData.addAll(reviewData);
            }
          }
        }
        rates = count > 0 ? rating / count : 0;
        groupData.addAll({'rates': rates});
      }

      // Add the combined data to the resultList
      resultList.add(groupData);
    }
    if (check) {
      return resultList;
    }
    return [];
  }

  Future<Map<String, dynamic>> getActiveRequest(String userId) async {
    Map<String, dynamic> resultMap = {};
    double rating = 0;
    double count = 0;
    double rates = 0;

    final checkQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('handymanId', isNull: false)
        .where('progress', whereIn: [
      'hired',
      'omw',
      'arrived',
      'inprogress',
      'completion',
      'rating'
    ]).get();

    if (checkQuery.docs.isNotEmpty) {
      for (var requestDoc in checkQuery.docs) {
        final requestData = requestDoc.data();
        final requestId = requestDoc.id;
        final clientId = requestData['userId'];
        final desc = requestData['description'];
        final handymanId = requestData['handymanId'];
        print(1);
        Map<String, dynamic> groupData = {
          ...requestData,
          'requestId': requestId,
          'clientId': clientId,
          'requestDesc': desc,
        };

        resultMap.addAll(groupData);
        final userQuery = await _db
            .collection('user')
            .where('userId', isEqualTo: handymanId)
            .get();

        // Process 'user' query results
        for (var userDoc in userQuery.docs) {
          final userData = userDoc.data();
          resultMap.addAll(userData);

          final handymanQuery1 = await _db
              .collection('handyman')
              .where('userId', isEqualTo: handymanId)
              .get();

          for (var handyDoc in handymanQuery1.docs) {
            final handyData = handyDoc.data();
            resultMap.addAll(handyData);

            // Query 'review' using key from userData
            final reviewsQuery = await _db
                .collection('review')
                .where('userId', isEqualTo: handymanId)
                .get();

            // Process 'review' query results
            for (var reviewDoc in reviewsQuery.docs) {
              final reviewData = reviewDoc.data();
              rating += reviewData['rating'];
              count++;
              resultMap.addAll(reviewData);
            }
          }
        }
        rates = count > 0 ? rating / count : 0;
        resultMap.addAll({'rates': rates});
      }
    } else {
      final requestQuery = await _db
          .collection('request')
          .where('userId', isEqualTo: userId)
          .where('progress', whereIn: [
        'hired',
        'omw',
        'arrived',
        'inprogress',
        'completion',
        'rating'
      ]).get();

      for (var requestDoc in requestQuery.docs) {
        final requestData = requestDoc.data();
        final requestId = requestDoc.id;
        final clientId = requestData['userId'];
        final desc = requestData['description'];

        Map<String, dynamic> groupData = {
          ...requestData,
          'requestId': requestId,
          'clientId': clientId,
          'requestDesc': desc,
        };

        resultMap.addAll(groupData);

        final handymanQuery = await _db
            .collection('handymanApproval')
            .where('requestId', isEqualTo: requestId)
            .where('status', whereIn: ['hired', 'rating']).get();

        if (handymanQuery.docs.isNotEmpty) {
          // Process 'handyman approval' query results
          for (var handymanDoc in handymanQuery.docs) {
            final handymanData = handymanDoc.data();
            resultMap.addAll(handymanData);
            // print(">>>>>>>>>>>>>$groupData");
            final userID = handymanData['handymanId'];

            final userQuery = await _db
                .collection('user')
                .where('userId', isEqualTo: userID)
                .get();

            // Process 'user' query results
            for (var userDoc in userQuery.docs) {
              final userData = userDoc.data();
              resultMap.addAll(userData);

              final handymanQuery1 = await _db
                  .collection('handyman')
                  .where('userId', isEqualTo: userID)
                  .get();

              for (var handyDoc in handymanQuery1.docs) {
                final handyData = handyDoc.data();
                resultMap.addAll(handyData);

                // Query 'review' using key from userData
                final reviewsQuery = await _db
                    .collection('review')
                    .where('userId', isEqualTo: userID)
                    .get();

                // Process 'review' query results
                for (var reviewDoc in reviewsQuery.docs) {
                  final reviewData = reviewDoc.data();
                  rating += reviewData['rating'];
                  count++;
                  resultMap.addAll(reviewData);
                }
              }
            }
          }
          rates = count > 0 ? rating / count : 0;
          resultMap.addAll({'rates': rates});
        } else {
          final offerQuery = await _db
              .collection('offer')
              .where('requestId', isEqualTo: requestId)
              .where('status', whereIn: ['hired', 'rating']).get();

          // Process 'handyman approval' query results
          for (var offerDoc in offerQuery.docs) {
            final offerData = offerDoc.data();
            resultMap.addAll(offerData);
            // print(">>>>>>>>>>>>>$groupData");
            final userID = offerData['userId'];

            final userQuery = await _db
                .collection('user')
                .where('userId', isEqualTo: userID)
                .get();

            // Process 'user' query results
            for (var userDoc in userQuery.docs) {
              final userData = userDoc.data();
              resultMap.addAll(userData);

              final handymanQuery1 = await _db
                  .collection('handyman')
                  .where('userId', isEqualTo: userID)
                  .get();

              for (var handyDoc in handymanQuery1.docs) {
                final handyData = handyDoc.data();
                resultMap.addAll(handyData);

                // Query 'review' using key from userData
                final reviewsQuery = await _db
                    .collection('review')
                    .where('userId', isEqualTo: userID)
                    .get();

                // Process 'review' query results
                for (var reviewDoc in reviewsQuery.docs) {
                  final reviewData = reviewDoc.data();
                  rating += reviewData['rating'];
                  count++;
                  resultMap.addAll(reviewData);
                }
              }
            }
          }
          rates = count > 0 ? rating / count : 0;
          resultMap.addAll({'rates': rates});
        }
      }
    }
    // print(">>>>>>>>>>>>>$resultMap");
    return resultMap;
  }

  Future<Map<String, dynamic>> getDirectRequest(String userId) async {
    Map<String, dynamic> resultMap = {};

    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'pending')
        .get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      final requestId = requestDoc.id;
      final desc = requestData['description'];
      final clientId = requestData['userId'];
      final handymanId = requestData['handymanId'];

      Map<String, dynamic> groupData = {
        ...requestData,
        'requestId': requestId,
        'requestDesc': desc,
        'clientId': clientId
      };

      resultMap.addAll(groupData);

      final userQuery = await _db
          .collection('user')
          .where('userId', isEqualTo: handymanId)
          .get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();
        resultMap.addAll(userData);

        final handymanQuery1 = await _db
            .collection('handyman')
            .where('userId', isEqualTo: handymanId)
            .get();

        for (var handyDoc in handymanQuery1.docs) {
          final handyData = handyDoc.data();
          resultMap.addAll(handyData);

          // Query 'review' using key from userData
          final reviewsQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: handymanId)
              .get();

          // Process 'review' query results
          for (var reviewDoc in reviewsQuery.docs) {
            final reviewData = reviewDoc.data();
            resultMap.addAll(reviewData);
          }
        }
      }

      final offerQuery = await _db
          .collection('offer')
          .where('requestId', isEqualTo: requestId)
          .where('status', isEqualTo: 'pending')
          .get();
      if (offerQuery.docs.isNotEmpty) {
        // Process 'handyman approval' query results
        for (var offerDoc in offerQuery.docs) {
          final offerData = offerDoc.data();
          resultMap.addAll(offerData);
        }
      }
    }
    // print(">>>>>>>>>>>>>$resultMap");
    return resultMap;
  }

  Future<Map<String, dynamic>> getActiveRequestClient(String handymanId) async {
    Map<String, dynamic> resultMap = {};

    final requestQuery = await _db
        .collection('request')
        .where('handymanId', isEqualTo: handymanId)
        .where('progress', whereIn: [
      'hired',
      'omw',
      'arrived',
      'inprogress',
      'completion',
      'rating',
    ]).get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      final requestId = requestDoc.id;
      final userId = requestData['userId'];
      final handymanId = requestData['handymanId'];
      Map<String, dynamic> groupData = {
        ...requestData,
        'requestId': requestId,
        'clientId': userId,
        'handymanId': handymanId
      };

      resultMap.addAll(groupData);

      final userQuery =
          await _db.collection('user').where('userId', isEqualTo: userId).get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();
        resultMap.addAll(userData);

        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: handymanId)
            .get();

        // Process 'user' query results
        for (var handymanDoc in handymanQuery.docs) {
          final handymanData = handymanDoc.data();
          print(handymanData);
          resultMap.addAll(handymanData);
          final reviewQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: userId)
              .get();

          // Process 'review' query results
          for (var reviewDoc in reviewQuery.docs) {
            final reviewData = reviewDoc.data();
            resultMap.addAll(reviewData);
          }
        }
      }
    }
    // print(">>>>>>>>>>>>>$resultMap");
    return resultMap;
  }

  Future<Map<String, dynamic>> getActiveRequestHandyman(String userId) async {
    Map<String, dynamic> resultMap = {};

    final offerQuery = await _db
        .collection('offer')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['pending', 'hired', 'rating']).get();

    if (offerQuery.docs.isNotEmpty) {
      for (var offerDoc in offerQuery.docs) {
        final offerData = offerDoc.data();
        final offerStatus = offerData['status'];
        final offerDesc = offerData['description'];
        final offerPic = offerData['attachment'];
        final requestId = offerData["requestId"];
        print('>>>>>>>>>>>>$offerData');
        resultMap.addAll({
          'approvalStatus': offerStatus,
          'hasOffer': true,
          'offerDesc': offerDesc,
          'offerPic': offerPic,
          'activeRequestId': requestId,
        });

        resultMap.addAll(offerData);
        // print(">>>>>>>>>>>>>>>>>>>$offerDesc");

        // Query 'request' using key from userData
        final requestQuery =
            await _db.collection('request').doc(requestId).get();

        // Process 'request' query results
        final requestData = requestQuery.data();
        if (requestData != null) {
          final clientId = requestData['userId'];
          resultMap.addAll(requestData);
          final userQuery = await _db
              .collection('user')
              .where('userId', isEqualTo: clientId)
              .get();

          for (var userDoc in userQuery.docs) {
            final userData = userDoc.data();
            resultMap.addAll(userData);

            final handymanQuery = await _db
                .collection('handyman')
                .where('userId', isEqualTo: userId)
                .get();

            // Process 'user' query results
            for (var handyDoc in handymanQuery.docs) {
              final handyData = handyDoc.data();
              resultMap.addAll(handyData);

              // Query 'review' using key from userData
              final reviewQuery = await _db
                  .collection('review')
                  .where('userId', isEqualTo: userId)
                  .get();

              // Process 'review' query results
              for (var reviewDoc in reviewQuery.docs) {
                final reviewData = reviewDoc.data();
                resultMap.addAll(reviewData);
              }
            }
          }
        }
      }
    } else {
      final approvalQuery = await _db
          .collection('handymanApproval')
          .where('handymanId', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'hired', 'rating']).get();

      for (var approvalDoc in approvalQuery.docs) {
        final approvalData = approvalDoc.data();
        final approvalStatus = approvalData['status'];
        final requestId = approvalData["requestId"];
        resultMap.addAll({
          'approvalStatus': approvalStatus,
          'hasOffer': false,
          'activeRequestId': requestId
        });

        resultMap.addAll(approvalData);

        // Query 'request' using key from userData
        final requestQuery =
            await _db.collection('request').doc(requestId).get();

        // Process 'request' query results
        final requestData = requestQuery.data();
        if (requestData != null) {
          resultMap.addAll(requestData);
          final userQuery = await _db
              .collection('user')
              .where('userId', isEqualTo: userId)
              .get();

          for (var userDoc in userQuery.docs) {
            final userData = userDoc.data();
            resultMap.addAll(userData);

            final handymanQuery = await _db
                .collection('handyman')
                .where('userId', isEqualTo: userId)
                .get();

            // Process 'user' query results
            for (var handyDoc in handymanQuery.docs) {
              final handyData = handyDoc.data();
              resultMap.addAll(handyData);
              // Query 'review' using key from userData
              final reviewQuery = await _db
                  .collection('review')
                  .where('userId', isEqualTo: userId)
                  .get();

              // Process 'review' query results
              for (var reviewDoc in reviewQuery.docs) {
                final reviewData = reviewDoc.data();
                resultMap.addAll(reviewData);
              }
            }
          }
        }
      }
    }

    // Query 'request' using key from userData
    final requestQuery = await _db
        .collection('request')
        .where('handymanId', isEqualTo: userId)
        .where('progress', whereIn: [
      'pending',
      'hired',
      'omw',
      'arrived',
      'inprogress',
      'completion'
    ]).get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      resultMap.addAll(requestData);
      final userQuery =
          await _db.collection('user').where('userId', isEqualTo: userId).get();

      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();
        resultMap.addAll(userData);

        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: userId)
            .get();

        // Process 'user' query results
        for (var handyDoc in handymanQuery.docs) {
          final handyData = handyDoc.data();
          resultMap.addAll(handyData);
          // Query 'review' using key from userData
          final reviewQuery = await _db
              .collection('review')
              .where('userId', isEqualTo: userId)
              .get();

          // Process 'review' query results
          for (var reviewDoc in reviewQuery.docs) {
            final reviewData = reviewDoc.data();
            resultMap.addAll(reviewData);
          }
        }
      }
    }

    return resultMap;
  }

  // OFFERS

  addOffers(Offer offerData) async {
    await _db.collection('offer').add(offerData.toFirestore());
  }

  Future<Offer> getOfferData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _db.collection('offer').doc(userId).get();

    return Offer.fromFireStore(docSnap);
  }

  Future<List<Map<String, dynamic>>> getInterestedHandymanAndOffer(
      String userId) async {
    List<Map<String, dynamic>> resultList = [];

    // Query 'request' collection using userId from 'offer'
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .where('progress', isEqualTo: 'pending')
        .get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      final requestId = requestDoc.id;
      final clientId = requestData['userId'];

      // Query 'offer' collection
      final offerQuery = await _db
          .collection('offer')
          .where('requestId', isEqualTo: requestId)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var offerDoc in offerQuery.docs) {
        final offerData = offerDoc.data();
        double rating = 0;
        double count = 0;
        double rates = 0;

        // Create a new groupData map for each offer
        Map<String, dynamic> groupData = {
          ...requestData,
          'NewRequestId': requestId,
          'clientId': clientId,
          ...offerData,
          'handymanId': offerData["userId"],
        };

        // Query 'handyman' collection using userId from 'offer'
        final handymanQuery = await _db
            .collection('handyman')
            .where('userId', isEqualTo: groupData['handymanId'])
            .get();

        for (var handymanDoc in handymanQuery.docs) {
          groupData.addAll(handymanDoc.data());

          // Query 'user' collection using userId from 'offer'
          final userQuery = await _db
              .collection('user')
              .where('userId', isEqualTo: groupData['handymanId'])
              .where('userRole', isEqualTo: 'handyman')
              .get();

          // Process 'user' query results
          for (var userDoc in userQuery.docs) {
            groupData.addAll(userDoc.data());

            // Query 'review' collection using some key from userData, adjust as needed
            final reviewQuery = await _db
                .collection('review')
                .where('userId', isEqualTo: groupData['handymanId'])
                .get();

            // Process 'review' query results
            for (var reviewDoc in reviewQuery.docs) {
              final reviewData = reviewDoc.data();
              rating += reviewData['rating'];
              count++;
              groupData.addAll(reviewData);
            }
          }
        }
        rates = count > 0 ? rating / count : 0;
        groupData.addAll({'rates': rates});

        // Add the combined data to the resultList
        resultList.add(groupData);
      }
    }

    return resultList;
  }

  // REVIEWS

  addReviews(Review reviewData) async {
    await _db
        .collection('review')
        .doc(reviewData.reviewId)
        .set(reviewData.toMap());
  }

  Future<Review> getReviewData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _db.collection('review').doc(userId).get();

    return Review.fromFireStore(docSnap);
  }

  // Get the information of user and its reviews
  Future<List<Map<String, dynamic>>> getHandymanReviews(String userId, String userRole) async {
    List<Map<String, dynamic>> resultList = [];
    // if user is client, get the request by userId, if user is handyman, get the request by handymanId
    //reviews
    //users

    final requestQuery;
    if (userRole == "client") {
      requestQuery =
        await _db.collection('request').where('progress', isEqualTo: 'completed').where('userId', isEqualTo: userId).get();
       
    } else {
      requestQuery =
        await _db.collection('request').where('progress', isEqualTo: 'completed').where('handymanId', isEqualTo: userId).get();
    }

    for (var requestDoc in requestQuery.docs) {
      
      final requestData = requestDoc.data();
      final requestId = requestDoc.id;
      print("++++++++++++++++++++++++++++ $requestId");
        // Query 'user' collection
      final reviewQuery =
          await _db.collection('review').where('requestId', isEqualTo: requestId).where('userId', isNotEqualTo: userId).get();

      // Process 'user' query results
      for (var reviewDoc in reviewQuery.docs) {
        print("testingggggg");
        final reviewData = reviewDoc.data();
        final userId = reviewData['userId'];

        final userQuery = await _db
            .collection('user')
            .where('userId', isEqualTo: userId)
            .get();

          // Process 'user' query results
          for (var userDoc in userQuery.docs) {
            final userData = userDoc.data();
            Map<String, dynamic> combinedData = {...requestData,...reviewData, ...userData};
            resultList.add(combinedData);
          }
        
      }

    }
  
    // Query 'user' collection
    // final reviewQuery =
    //     await _db.collection('review').where('userId', isEqualTo: userId).get();

    // // Process 'user' query results
    // for (var reviewDoc in reviewQuery.docs) {
    //   final reviewData = reviewDoc.data();
    //   final requestId = reviewData['requestId'];

    //   final requestDoc = await _db.collection('request').doc(requestId).get();

    //   // Process 'request' query results
    //   if (requestDoc.exists) {
    //     final requestData = requestDoc.data();
    //     final clientId = requestData!['userId'];

    //     final userQuery = await _db
    //         .collection('user')
    //         .where('userId', isEqualTo: clientId)
    //         .get();

    //     // Process 'user' query results
    //     for (var userDoc in userQuery.docs) {
    //       final userData = userDoc.data();
    //       Map<String, dynamic> combinedData = {...reviewData, ...userData};
    //       resultList.add(combinedData);
    //     }
    //   }
    // }

    return resultList;
  }

  // REPORTS

  addReports(Report reportData) async {
    await _db
        .collection('report')
        .doc(reportData.reportId)
        .set(reportData.toMap());
  }

  Future<Report> getReportData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _db.collection('report').doc(userId).get();

    return Report.fromFireStore(docSnap);
  }

  // Get all the reports
  Future<List<Report>> getAllReportData(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _db.collection('report').where('userId', isEqualTo: userId).get();

    List<Report> reportList = querySnapshot.docs.map((doc) {
      return Report.fromFireStore(doc);
    }).toList();

    return reportList;
  }

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

  //authenticating username
  Future<String?> getEmailFromUsername(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('user')
          .where('username', isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('emailAdd');
      } else {
        return null; // Username not found
      }
    } catch (e) {
      print('Error retrieving email from username: $e');
      return null;
    }
  }
}
