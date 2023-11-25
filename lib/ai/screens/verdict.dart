import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laborlink/ai/screens/dummy.dart';
import 'package:laborlink/ai/screens/splash_one.dart';
import 'package:laborlink/ai/style.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/providers/saved_client_provider.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class VerdictPage extends ConsumerStatefulWidget {
  const VerdictPage(
      {super.key,
      required this.outputs,
      this.regulaOutputs,
      required this.isSuccessful});

  final List<String> outputs;
  final List<double>? regulaOutputs;
  final bool isSuccessful;

  @override
  ConsumerState<VerdictPage> createState() => _VerdictPageState();
}

class _VerdictPageState extends ConsumerState<VerdictPage> {
  Widget button = const SizedBox();

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
      if (widget.regulaOutputs![0] == 0.0 && widget.regulaOutputs![1] == 0.0) {
        description = 'Both IDs don\'t match';
      } else {
        description = 'One of your IDs doesn\'t match';
      }
    }

    if (widget.isSuccessful) description = 'We\'re good to go!';

    return description;
  }

  showButton() {
    Widget route = const DummyPage();
    if (widget.isSuccessful) route = const SplashOnePage();
    Widget delayed;

    delayed = TextButton(
      onPressed: () {
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
    });
  }

  createClientAccount() async {
    Map<String, dynamic> savedUserData;
    savedUserData = ref.watch(savedClientDataProvider);

    // Create a user in Firebase Authentication
    DatabaseService service = DatabaseService();
    UserCredential userCredential =
        await _firebase.createUserWithEmailAndPassword(
            email: savedUserData["email"], password: savedUserData["password"]);

    // Upload files to Firebase Storage
    String imageUrl = await service.uploadNBIClearance(
        userCredential.user!.uid, savedUserData["idFile"]);

    Client client = Client(
        userId: userCredential.user!.uid,
        userRole: "client",
        firstName: savedUserData["first_name"],
        lastName: savedUserData["last_name"],
        middleName: savedUserData["middle_name"],
        suffix: savedUserData["suffix"],
        dob: savedUserData["birthday"],
        sex: savedUserData["gender"],
        streetAddress: savedUserData["street"],
        state: savedUserData["savedUserData"],
        city: savedUserData["city"],
        zipCode: int.parse(savedUserData["zip"]),
        emailAdd: savedUserData["email"],
        username: savedUserData["username"],
        phoneNumber: savedUserData["phone"],
        validId: savedUserData["idType"],
        idProof: imageUrl);

    // Firestore
    await service.addUser(client);
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      showButton();
    });
    if (widget.isSuccessful) createClientAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String description = processOutputs();
    Widget lottie = Lottie.asset('assets/animations/wrong.json');

    if (widget.isSuccessful) {
      lottie = Lottie.asset('assets/animations/check.json');
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
          button,
        ],
      ),
    );
  }
}
