import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Forms/AccountDetailsForm.dart';
import 'package:laborlink/Widgets/Forms/AddressForm.dart';
import 'package:laborlink/Widgets/Forms/BasicInformationForm.dart';
import 'package:laborlink/Widgets/Forms/ClientRequirementForm.dart';
import 'package:laborlink/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'dart:async';
import 'package:laborlink/ai/screens/id_verification.dart';
import 'package:laborlink/splash/splash_one.dart';

final _firebase = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class ClientRegistrationPage extends StatefulWidget {
  const ClientRegistrationPage({Key? key}) : super(key: key);

  @override
  State<ClientRegistrationPage> createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  GlobalKey<BasicInformationFormState> basicInformationFormKey =
      GlobalKey<BasicInformationFormState>();
  GlobalKey<AddressFormState> addressFormKey = GlobalKey<AddressFormState>();
  GlobalKey<AccountDetailsFormState> accountDetailsFormKey =
      GlobalKey<AccountDetailsFormState>();
  GlobalKey<ClientRequirementFormState> clientRequirementFormKey =
      GlobalKey<ClientRequirementFormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const SplashOnePage();
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
              child: ClientRequirementForm(
                key: clientRequirementFormKey,
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
                fontSize: 18,
                height: 42,
                text: "BACK",
                color: AppColors.tertiaryBlue,
                command: onBack,
                borderRadius: 8),
            AppFilledButton(
                padding: const EdgeInsets.only(left: 18),
                fontFamily: AppFonts.poppins,
                fontSize: 18,
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

  Future<void> onProceed() async {
    setState(() {
      basicInformationFormKey.currentState!.isAutoValidationEnabled = true;
      accountDetailsFormKey.currentState!.isAutoValidationEnabled = true;
      addressFormKey.currentState!.isAutoValidationEnabled = true;
      clientRequirementFormKey.currentState!.isAutoValidationEnabled = true;
    });

    // Validate the forms
    if (clientRequirementFormKey.currentState!.hasFile()) {
      if (basicInformationFormKey.currentState!.validateForm() &&
          addressFormKey.currentState!.validateForm() &&
          accountDetailsFormKey.currentState!.validateForm() &&
          clientRequirementFormKey.currentState!.validateForm()) {
        // Form is valid, you can proceed with further actions

        // Get the form data
        Map<String, dynamic> basicInfo =
            basicInformationFormKey.currentState!.getFormData;

        Map<String, dynamic> addressInfo =
            addressFormKey.currentState!.getFormData;

        Map<String, dynamic> accountInfo =
            accountDetailsFormKey.currentState!.getFormData;

        Map<String, dynamic> clientInfo =
            clientRequirementFormKey.currentState!.getFormData;

        // Check if the email is unique

        // if (emailSnapshot.docs.isNotEmpty) {
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

        // if (usernameSnapshot.docs.isNotEmpty) {
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
          // Create a user in Firebase Authentication
          DatabaseService service = DatabaseService();
          UserCredential userCredential =
              await _firebase.createUserWithEmailAndPassword(
                  email: accountInfo["email"],
                  password: accountInfo["password"]);

          // Get the current date and time
          // DateTime now = DateTime.now();
          // Convert the DateTime to a string in a suitable format
          // String currentDate =
          //     "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
          // Upload files to Firebase Storage
          String imageUrl = await service.uploadNBIClearance(
              userCredential.user!.uid, clientInfo["idFile"]);

          Client client = Client(
              userId: userCredential.user!.uid,
              userRole: "client",
              firstName: basicInfo["first_name"],
              lastName: basicInfo["last_name"],
              middleName: basicInfo["middle_name"],
              suffix: basicInfo["suffix"],
              dob: basicInfo["birthday"],
              sex: basicInfo["gender"],
              streetAddress: addressInfo["street"],
              state: addressInfo["state"],
              city: addressInfo["city"],
              zipCode: int.parse(addressInfo["zip"]),
              emailAdd: accountInfo["email"],
              username: accountInfo["username"],
              phoneNumber: accountInfo["phone"],
              validId: clientInfo["idType"],
              idProof: imageUrl);

          await service.addUser(client);

          // Continue with your navigation or any other logic
          List<Map<String, dynamic>> fileAttachments;

          fileAttachments = [
            {
              'type': clientInfo['idType'],
              'file': clientInfo['idFile'],
            }
          ];

          _toIdVerification(fileAttachments);

          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => const FaceDetectionPage(),
          // ));
        } catch (e) {
          // Handle errors during user creation
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
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show an error message for not uploading a file
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a file."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
