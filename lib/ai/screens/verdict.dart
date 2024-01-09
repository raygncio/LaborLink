import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/Pages/Registration/TermsAndConditionPage.dart';
import 'package:laborlink/ai/screens/dummy.dart';
import 'package:laborlink/ai/screens/splash_one.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/models/results/face_results.dart';
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

  Future<File> imageToFile({String imageName, String ext}) async {
    var bytes = await rootBundle.load('assets/$imageName.$ext');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  _recordResults() async {
    DatabaseService service = DatabaseService();
    FaceResults faceResults;
    List<Image>? resultImages = widget.images;
    List<double>? regulaResults = widget.regulaOutputs;

    if (resultImages == null || regulaResults == null) return;

    for (var i = 0; i < resultImages.length; i++) {
      // Upload files to Firebase Storage
      String imageUrl = await service.uploadFace(i.toString(), resultImages[i]);

      anomalyResults = AnomalyResults(
          idType: files[i]['type'], attachment: imageUrl, result: outputs[i]);
      await service.addAnomalyResult(anomalyResults);
    }
  }

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
      // isRegistered = true;
    });
  }

  createClientAccount() async {
    print('>>>>>>>>>>>>>>>>>>>>create client account');
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

    setState(() {
      isRegistered = true;
    });
  }

  createHandymanAccount() async {
    print('>>>>>>>>>>>>>>>>>>>>create handyman account');
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

    setState(() {
      isRegistered = true;
    });
  }

  showResultsButton() {
    setState(() {
      resultsButton = TextButton(
        onPressed: showResultsDialog,
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        content: Container(
          height: 230,
          width: double.infinity,
          child: Column(
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
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var image in resultImages)
                        Container(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                          ),
                          width: 150,
                          child: image,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              for (var result in regulaResults)
                Text('Match Percentage: $result'),
            ],
          ),
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
    print('>>>>>>>>>>>isSuccessful: ${widget.isSuccessful}');
    if (widget.isSuccessful) {
      savedUserData = ref.watch(registrationDataProvider);
    }

    if (!isRegistered && savedUserData.isNotEmpty) {
      print('>>>>>>>>>>>savedUserData.isNotEmpty: ${savedUserData.isNotEmpty}');
      if (savedUserData['userRole'] == 'client') {
        //print('>>>>>>create client account');
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
