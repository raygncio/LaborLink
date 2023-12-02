import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Registration/FaceDetectionPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Forms/AccountDetailsForm.dart';
import 'package:laborlink/Widgets/Forms/AddressForm.dart';
import 'package:laborlink/Widgets/Forms/BasicInformationForm.dart';
import 'package:laborlink/Widgets/Forms/ClientRequirementForm.dart';
import 'package:laborlink/Widgets/Forms/HandymanRequirementForm.dart';
import 'package:laborlink/ai/screens/id_verification.dart';
import 'package:laborlink/providers/registration_data_provider.dart';
import 'package:laborlink/splash/splash_handyman.dart';
import 'package:laborlink/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firebase = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class HandymanRegistrationPage extends ConsumerStatefulWidget {
  const HandymanRegistrationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HandymanRegistrationPage> createState() =>
      _HandymanRegistrationPageState();
}

class _HandymanRegistrationPageState
    extends ConsumerState<HandymanRegistrationPage> {
  GlobalKey<BasicInformationFormState> basicInformationFormKey =
      GlobalKey<BasicInformationFormState>();
  GlobalKey<AddressFormState> addressFormKey = GlobalKey<AddressFormState>();
  GlobalKey<AccountDetailsFormState> accountDetailsFormKey =
      GlobalKey<AccountDetailsFormState>();
  GlobalKey<HandymanRequirementFormState> handymanRequirementFormKey =
      GlobalKey<HandymanRequirementFormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const SplashHandymanPage();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: deviceWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 64, bottom: 39),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create an account",
                        style: getTextStyle(
                            textColor: AppColors.tertiaryBlue,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "Please provide all the information marked with asterisks.",
                        overflow: TextOverflow.visible,
                        style: getTextStyle(
                            textColor: AppColors.tertiaryBlue,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.normal,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
                formsSection(),
                buttonSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formsSection() => Padding(
        padding: const EdgeInsets.only(left: 13, right: 13, top: 14),
        child: Column(
          children: [
            BasicInformationForm(key: basicInformationFormKey),
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: AddressForm(
                key: addressFormKey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: AccountDetailsForm(
                key: accountDetailsFormKey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: HandymanRequirementForm(
                key: handymanRequirementFormKey,
              ),
            ),
          ],
        ),
      );

  Widget buttonSection() => Padding(
        padding: const EdgeInsets.only(left: 28, right: 28, top: 23),
        child: Row(
          children: [
            AppFilledButton(
                padding: const EdgeInsets.only(right: 18),
                fontFamily: AppFonts.poppins,
                fontSize: 15,
                height: 42,
                text: "BACK",
                color: AppColors.tertiaryBlue,
                command: onBack,
                borderRadius: 8),
            AppFilledButton(
                padding: const EdgeInsets.only(left: 18),
                fontFamily: AppFonts.poppins,
                fontSize: 15,
                height: 42,
                text: "PROCEED",
                color: AppColors.accentOrange,
                command: onProceed,
                borderRadius: 8),
          ],
        ),
      );

  void onBack() {
    Navigator.of(context).pop();
  }

  void _toIdVerification(List<Map<String, dynamic>> data) {
    setState(() {
      _isLoading = true;
    });
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => IdVerification(
              data: data,
            ),
          ),
        );
      },
    );
  }

  void onProceed() async {
    setState(() {
      basicInformationFormKey.currentState!.isAutoValidationEnabled = true;
      accountDetailsFormKey.currentState!.isAutoValidationEnabled = true;
      addressFormKey.currentState!.isAutoValidationEnabled = true;
      handymanRequirementFormKey.currentState!.isAutoValidationEnabled = true;
    });

    // Validate the forms
    if (handymanRequirementFormKey.currentState!.hasFile()) {
      if (basicInformationFormKey.currentState!.validateForm() &&
          addressFormKey.currentState!.validateForm() &&
          accountDetailsFormKey.currentState!.validateForm() &&
          handymanRequirementFormKey.currentState!.validateForm()) {
        // Form is valid, you can proceed with further actions

        // Get the form data
        Map<String, dynamic> basicInfo =
            basicInformationFormKey.currentState!.getFormData;

        Map<String, dynamic> addressInfo =
            addressFormKey.currentState!.getFormData;

        Map<String, dynamic> accountInfo =
            accountDetailsFormKey.currentState!.getFormData;

        Map<String, dynamic> handymanInfo =
            handymanRequirementFormKey.currentState!.getFormData;

        // Check if the email is unique

        // if (emailSnapshot.snapshot.value != null) {
        //   // Email already exists, show an error or handle accordingly
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("Email already exists"),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        //   return;
        // }

        // Check if the username is unique

        // if (usernameSnapshot.snapshot.value != null) {
        //   // Username already exists, show an error or handle accordingly
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("Username already exists"),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        //   return;
        // }

        try {
          // save entered registration data
          Map<String, dynamic> savedHandymanDataMap = {
            ...basicInfo,
            ...addressInfo,
            ...accountInfo,
            ...handymanInfo,
            'userRole': 'handyman',
          };
          ref
              .read(registrationDataProvider.notifier)
              .saveRegistrationData(savedHandymanDataMap);

          // Verify Credentials First before creating user and storing user data
          List<Map<String, dynamic>> fileAttachments;

          fileAttachments = [
            {
              'type': 'nbi',
              'file': handymanInfo['idFile'],
            },
            {
              'type': 'tesda',
              'file': handymanInfo['certProofFile'],
            }
          ];

          // jumps to id verification
          _toIdVerification(fileAttachments);
        } catch (e) {
          // Handle errors during user creation
          print("Error creating user: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error creating user"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Invalid Error! Please double check your information."),
            backgroundColor: Color.fromARGB(255, 245, 27, 11),
          ),
        );
      }
    } else {
      // Show an error message for not uploading a file
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a file."),
          backgroundColor: Color.fromARGB(255, 245, 27, 11),
        ),
      );
    }
  }

  // Specialization _convertToSpecialization(String? specializationString) {
  //   if (specializationString != null) {
  //     try {
  //       return Specialization.values.firstWhere(
  //           (e) => e.toString().split('.').last == specializationString);
  //     } catch (e) {
  //       print("Error converting specialization: $e");
  //       // Handle the case where no matching specialization is found
  //       // You can return a default value or throw an error, depending on your logic
  //     }
  //   }
  //   // Return a default specialization or handle accordingly
  //   return Specialization.plumbing; // Change this to your default value
  // }
}
