import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/Pages/Registration/TermsAndConditionPage.dart';
import 'package:laborlink/ai/screens/dummy.dart';
import 'package:laborlink/ai/screens/splash_one.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/services/analytics_service.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/providers/registration_data_provider.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;
final AnalyticsService _analytics = AnalyticsService();

class VerdictPage extends ConsumerStatefulWidget {
  const VerdictPage(
      {super.key,
      required this.outputs,
      this.regulaOutputs,
      this.images,
      required this.isSuccessful});

  final List<String> outputs;
  final List<double>? regulaOutputs;
  final List<Image>? images;
  final bool isSuccessful;

  @override
  ConsumerState<VerdictPage> createState() => _VerdictPageState();
}

class _VerdictPageState extends ConsumerState<VerdictPage> {
  Widget resultsButton = const SizedBox();
  Widget button = const SizedBox();
  Map<String, dynamic> savedUserData = {};
  bool isRegistered = false;

  bool hasFaceResults = false;

  checkFaceResults() {
    if (widget.images != null && widget.regulaOutputs != null) {
      return true;
    }
    return false;
  }

  String processOutputs() {
    if (widget.outputs.isEmpty) return '';

    String description = '';
    // error messages only --

    // for fake detection
    if (widget.outputs.toString().contains('anomaly')) {
      if (widget.outputs.length > 1) {
        if (widget.outputs[0] == widget.outputs[1]) {
          description = 'Both IDs have anomalies';
        } else {
          description = 'One of your ID has anomalies';
        }
      } else {
        description = 'Your ID has anomalies';
      }
    }

    // for face detection
    if (widget.outputs.toString().contains('nomatch')) {
      if (widget.outputs.length > 1) {
        if (widget.outputs[0] == widget.outputs[1]) {
          description = 'Both IDs don\'t match';
        } else {
          description = 'One of your IDs doesn\'t match';
        }
      } else {
        description = 'ID doesn\'t match';
      }
    }

    // regula face match double check [override]
    if (!widget.isSuccessful && widget.regulaOutputs != null) {
      if (widget.regulaOutputs!.length > 1) {
        if (widget.regulaOutputs![0] == 0.0 &&
            widget.regulaOutputs![1] == 0.0) {
          description = 'Both IDs don\'t match';
        } else {
          description = 'One of your IDs doesn\'t match';
        }
      } else {
        description = 'ID doesn\'t match';
      }
    }

    if (widget.isSuccessful) description = 'We\'re good to go!';

    return description;
  }

  showButton() {
    Widget route = const LoginPage();
    if (widget.isSuccessful) route = const TermsAndConditionPage();
    Widget delayed;

    delayed = TextButton(
      onPressed: () {
        ref.invalidate(registrationDataProvider);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              return route;
            },
          ),
        );
      },
      style: TextButton.styleFrom(backgroundColor: AppColors.primaryBlue),
      child: Text(
        widget.isSuccessful ? 'Continue' : 'I understand',
        style: getTextStyle(
            textColor: AppColors.white,
            fontFamily: AppFonts.poppins,
            fontWeight: AppFontWeights.medium,
            fontSize: 20),
      ),
    );

    setState(() {
      button = delayed;
      isRegistered = true;
    });
  }

  createClientAccount() async {
    print(savedUserData);

    // Create a user in Firebase Authentication
    DatabaseService service = DatabaseService();
    try {
      UserCredential userCredential =
          await _firebase.createUserWithEmailAndPassword(
              email: savedUserData["email"],
              password: savedUserData["password"]);

      await _analytics.setUserProperties(
          userId: userCredential.user!.uid,
          userRole: savedUserData['userRole']);

      // Upload files to Firebase Storage
      String imageUrl = await service.uploadNBIClearance(
          userCredential.user!.uid, savedUserData["idFile"]);

      Client client = Client(
          userId: userCredential.user!.uid,
          userRole: savedUserData["userRole"],
          firstName: savedUserData["first_name"],
          lastName: savedUserData["last_name"],
          middleName: savedUserData["middle_name"],
          suffix: savedUserData["suffix"],
          dob: savedUserData["birthday"],
          sex: savedUserData["gender"],
          streetAddress: savedUserData["street"],
          state: savedUserData["state"],
          city: savedUserData["city"],
          zipCode: int.parse(savedUserData["zip"]),
          emailAdd: savedUserData["email"],
          username: savedUserData["username"],
          phoneNumber: savedUserData["phone"],
          validId: savedUserData["idType"],
          idProof: imageUrl);

      // Firestore
      await service.addUser(client);
    } on FirebaseAuthException catch (error) {
      print('Error fetching user data: $error');
    }
  }

  createHandymanAccount() async {
    print(savedUserData);

    // Create a user in Firebase Authentication
    DatabaseService service = DatabaseService();

    try {
      UserCredential userCredential =
          await _firebase.createUserWithEmailAndPassword(
              email: savedUserData["email"],
              password: savedUserData["password"]);

      await _analytics.setUserProperties(
          userId: userCredential.user!.uid,
          userRole: savedUserData['userRole']);

      //for uploading nbi clearance
      String imageUrl = await service.uploadNBIClearance(
          userCredential.user!.uid, savedUserData["idFile"]);

      String recommendationUrl = '';
      if (savedUserData["recLetterFile"] != null) {
        //for uploading recommendation letter
        recommendationUrl = await service.uploadRecommendationLetter(
            userCredential.user!.uid, savedUserData["recLetterFile"]);
      }

      //for uploading TESDA certification
      String tesdaUrl = await service.uploadTesda(
          userCredential.user!.uid, savedUserData["certProofFile"]);

      Client client = Client(
          userId: userCredential.user!.uid,
          userRole: "handyman",
          firstName: savedUserData["first_name"],
          lastName: savedUserData["last_name"],
          middleName: savedUserData["middle_name"],
          suffix: savedUserData["suffix"],
          dob: savedUserData["birthday"],
          sex: savedUserData["gender"],
          streetAddress: savedUserData["street"],
          state: savedUserData["state"],
          city: savedUserData["city"],
          zipCode: int.parse(savedUserData["zip"]),
          emailAdd: savedUserData["email"],
          username: savedUserData["username"],
          phoneNumber: savedUserData["phone"],
          validId: savedUserData["idType"],
          idProof: imageUrl);

      print(savedUserData["specialization"]);

      Handyman handyman = Handyman(
        applicantStatus: "pending",
        specialization: savedUserData["specialization"],
        employer: savedUserData["employer"],
        nbiClearance: imageUrl,
        certification: savedUserData["certificateName"],
        certificationProof: tesdaUrl,
        recommendationLetter: recommendationUrl,
        userId: userCredential.user!.uid,
      );

      await service.addUser(client);
      await service.addHandyman(handyman);
    } on FirebaseAuthException catch (error) {
      print('>>>>>>>>>>>>>>>>>>>>Error fetching user data: $error');
    }
  }

  showResultsButton() {
    setState(() {
      resultsButton = TextButton(
        onPressed: () {},
        child: Text(
          'Show Results',
          style: getTextStyle(
              textColor: AppColors.primaryBlue,
              fontFamily: AppFonts.montserrat,
              fontWeight: AppFontWeights.bold,
              fontSize: 15),
        ),
      );
    });
  }

  showResultsDialog() {
    List<Image> resultImages = widget.images!;
    List<double> regulaResults = widget.regulaOutputs!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: resultImages.length,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       width: 200,
            //       child: resultImages[index],
            //     );
            //   },
            // ),
            Row(
              children: [
                for (var image in resultImages)
                  Container(
                    width: 200,
                    child: image,
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (var result in regulaResults) Text('$result'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Okay',
              style: getTextStyle(
                  textColor: AppColors.primaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      showButton();
    });
    hasFaceResults = checkFaceResults();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSuccessful) {
      savedUserData = ref.watch(registrationDataProvider);
    }

    if (!isRegistered && savedUserData.isNotEmpty) {
      if (savedUserData['userRole'] == 'client') {
        createClientAccount();
      }
      if (savedUserData['userRole'] == 'handyman') {
        createHandymanAccount();
      }
    }

    String description = processOutputs();
    Widget lottie = Lottie.asset('assets/animations/wrong.json');

    if (widget.isSuccessful) {
      lottie = Lottie.asset('assets/animations/check.json');
    }

    if (hasFaceResults) {
      showResultsButton();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: lottie,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            description,
            style: getTextStyle(
                textColor: AppColors.primaryBlue,
                fontFamily: AppFonts.poppins,
                fontWeight: AppFontWeights.bold,
                fontSize: 20),
          ),
          const SizedBox(
            height: 15,
          ),
          resultsButton,
          button,
        ],
      ),
    );
  }
}
