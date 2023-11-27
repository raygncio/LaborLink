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
import 'package:laborlink/services/analytics_service.dart';

class UserAndRequest {
  final Client client;
  final Request request;

  UserAndRequest({required this.client, required this.request});
}

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

  // For report attachments
  Future<String> uploadReportAttachment(
      String userId, File selectedImage) async {
    String filename = '$userId-${DateTime.now()}';
    final reportStorage = _storage.ref().child('report').child('$filename.jpg');
    await reportStorage.putFile(selectedImage);
    final imageUrl = await reportStorage.getDownloadURL();

    return imageUrl;
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

  // Future<Client> getUserDataByName(String name) async {
  //   final querySnap =
  //       await _db.collection('user').where('firstName', isEqualTo: name).get();

  //   return Client.fromFireStore(querySnap.docs.first);
  // }

  // Search handyman and its data
  Future<List<Map<String, dynamic>>> getUserAndHandymanDataByFirstName(
      String searchText) async {
    List<Map<String, dynamic>> resultList = [];
    List<String> categoriesToCheck = [
      'plumbing',
      'installation',
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

          // Combine user and handyman data into a single map
          Map<String, dynamic> combinedData = {...userData, ...handymanData};
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

          // Combine user and handyman data into a single map
          Map<String, dynamic> combinedData = {...userData, ...handymanData};
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
      'installation',
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

        // Query 'request' collection using userId
        final requestQuery = await _db
            .collection('request')
            .where('userId', isEqualTo: userId)
            .where('category', isEqualTo: searchText)
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

  // Update the getAllUserAndItsRequest method
  Future<List<UserAndRequest>> getAllUserAndItsRequest(String userId) async {
    List<UserAndRequest> resultList = [];

    // // Query 'user' collection
    // final userQuery = await _db.collection('user').get();

    // // Loop through each user document
    // for (QueryDocumentSnapshot userDoc in userQuery.docs) {
    //   // Get user data
    //   Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    //   // Create a Client instance from the user data
    //   Client client = Client.fromFireStore(userData);

    //   // Query 'request' collection using userId
    //   final requestQuery = await _db
    //       .collection('request')
    //       .where('userId', isEqualTo: userDoc.id)
    //       .get();

    //   // Get list of requests for this user
    //   List<Map<String, dynamic>> requestList = requestQuery.docs
    //       .map((requestDoc) => requestDoc.data() as Map<String, dynamic>)
    //       .toList();

    //   // Create a UserAndRequest object and add it to the result list
    //   UserAndRequest userAndRequest =
    //       UserAndRequest(client: client, request: requestList);
    //   resultList.add(userAndRequest);
    // }

    return resultList;
  }

  // Get direct request of handyman
  Future<List<Map<String, dynamic>>> getDirectRequestOfHandyman(
      String handymanId) async {
    List<Map<String, dynamic>> resultList = [];
    // Query 'user' collection
    final handymanQuery = await _db
        .collection('handymanApproval')
        .where('handymanId', isEqualTo: handymanId)
        .where('status', isEqualTo: 'direct')
        .get();

    // Process 'user' query results
    for (var handymanDoc in handymanQuery.docs) {
      final handymanId = handymanDoc.id;
      //print(handymanId); doc id
      final handymanData = handymanDoc.data();
      // Access specific fields from handymanData
      final requestId = handymanData['requestId'];
      print(handymanDoc.data());
      // Query 'request' collection using requestId
      final requestQuery = await _db
          .collection('request')
          .where('userId', isEqualTo: requestId)
          .where('handymanId', isEqualTo: handymanId)
          .get();

      // Process 'request' query results
      for (var requestDoc in requestQuery.docs) {
        final requestData = requestDoc.data();
        print(requestData);
        // Combine handyman and request data into a single map
        Map<String, dynamic> combinedData = {...handymanData, ...requestData};
        resultList.add(combinedData);
      }
    }
    print(resultList);
    return resultList;
  }

  Future<Request?> getRequestsData(String userId) async {
    final querySnap = await _db
        .collection('request')
        .where('progress', whereIn: ['pending', 'inprogress'])
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
        .where('progress', whereIn: ['pending', 'inprogress'])
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

  // Update the progress to cancelled request
  Future<void> cancelRequest(String userId) async {
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in requestQuery.docs) {
      await doc.reference.update({
        'progress': 'cancelled',
      });
    }
  }

  // Update the progress to cancelled request
  Future<void> declineDirectRequest(String requestId) async {
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: requestId)
        .get();

    for (var doc in requestQuery.docs) {
      await doc.reference.update({
        'handymanId': '',
      });
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

  // Get all interested handyman
  Future<List<Map<String, dynamic>>> getInterestedHandyman(
      String requestId) async {
    List<Map<String, dynamic>> resultList = [];

    // Query 'handymanApproval' collection
    final handymanQuery = await _db
        .collection('handymanApproval')
        .where('requestId', isEqualTo: requestId)
        .get();

    // Process 'handymanApproval' query results
    for (var handymanDoc in handymanQuery.docs) {
      final handymanData = handymanDoc.data();
      final handymanId = handymanData["handymanId"];

      // Query 'user' collection using handymanId
      final userQuery = await _db
          .collection('user')
          .where('userId', isEqualTo: handymanId)
          .get();

      // Process 'user' query results
      for (var userDoc in userQuery.docs) {
        final userData = userDoc.data();

        // Query 'reviewCollection' using some key from userData
        final reviewsQuery = await _db
            .collection('reviews')
            .where('userId', isEqualTo: handymanId)
            .get();

        // Process 'reviewCollection' query results
        for (var reviewDoc in reviewsQuery.docs) {
          final reviewData = reviewDoc.data();

          // Combine all data into a single map
          Map<String, dynamic> combinedData = {
            ...userData,
            ...handymanData,
            ...reviewData
          };
          resultList.add(combinedData);
        }
      }
    }
    return resultList;
  }

  // OFFERS

  addOffers(Offer offerData) async {
    await _db
        .collection('offer')
        .doc(offerData.offerId)
        .set(offerData.toFirestore());
  }

  Future<Offer> getOfferData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _db.collection('offer').doc(userId).get();

    return Offer.fromFireStore(docSnap);
  }

  // Get all interested handyman and its offers to the request
  Future<List<Map<String, dynamic>>> getInterestedHandymanAndOffer(
      String requestId) async {
    List<Map<String, dynamic>> resultList = [];

    // Query 'request' collection using userId from 'offer'
    final requestQuery = await _db
        .collection('request')
        .where('userId', isEqualTo: requestId)
        .get();

    for (var requestDoc in requestQuery.docs) {
      final requestData = requestDoc.data();
      // Query 'offer' collection
      final offerQuery = await _db
          .collection('offer')
          .where('requestId', isEqualTo: requestId)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var offerDoc in offerQuery.docs) {
        final offerData = offerDoc.data();
        final userIdOnOffer = offerData["userId"];

        // Query 'user' collection using userId from 'offer'
        final userQuery = await _db
            .collection('user')
            .where('userId', isEqualTo: userIdOnOffer)
            .where('userRole', isEqualTo: 'handyman')
            .get();

        // Process 'user' query results
        for (var userDoc in userQuery.docs) {
          final userData = userDoc.data();

          // Query 'review' collection using some key from userData, adjust as needed
          final reviewQuery = await _db
              .collection('reviews')
              .where('userId', isEqualTo: userIdOnOffer)
              .get();

          // Process 'review' query results
          for (var reviewDoc in reviewQuery.docs) {
            final reviewData = reviewDoc.data();

            // Combine all data into a single map
            Map<String, dynamic> combinedData = {
              ...requestData,
              ...offerData,
              ...userData,
              ...reviewData
            };
            resultList.add(combinedData);
          }
        }
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
