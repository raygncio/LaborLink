import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Registration/FaceDetectionPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Forms/AccountDetailsForm.dart';
import 'package:laborlink/Widgets/Forms/AddressForm.dart';
import 'package:laborlink/Widgets/Forms/BasicInformationForm.dart';
import 'package:laborlink/Widgets/Forms/ClientRequirementForm.dart';
import 'package:laborlink/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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

  Future<void> onProceed() async {
    Uuid uuid = Uuid();

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
        QuerySnapshot emailSnapshot = await _firestore
            .collection("users")
            .where("email_add", isEqualTo: accountInfo["email"])
            .get();

        if (emailSnapshot.docs.isNotEmpty) {
          // Email already exists, show an error or handle accordingly
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email already exists"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Check if the username is unique
        QuerySnapshot usernameSnapshot = await _firestore
            .collection("users")
            .where("username", isEqualTo: accountInfo["username"])
            .get();

        if (usernameSnapshot.docs.isNotEmpty) {
          // Username already exists, show an error or handle accordingly
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Username already exists"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        try {
          // Create a user in Firebase Authentication
          UserCredential userCredential =
              await _firebase.createUserWithEmailAndPassword(
                  email: accountInfo["email"],
                  password: accountInfo["password"]);

          // Get the UID of the newly created user
          String userId = userCredential.user!.uid;

          // Get the current date and time
          DateTime now = DateTime.now();
          // Convert the DateTime to a string in a suitable format
          String currentDate =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          CollectionReference userCollection = _firestore.collection("users");

          // Add user data to Firestore
          await userCollection.doc(userId).set({
            "city": addressInfo["city"] ?? "",
            "created_at": currentDate,
            "dob": basicInfo["birthday"] ?? "",
            "email_add": accountInfo["email"] ?? "",
            "first_name": basicInfo["first_name"] ?? "",
            "id_proof": clientInfo["idFileName"] ?? "",
            "last_name": basicInfo["last_name"] ?? "",
            "middle_name": basicInfo["middle_name"] ?? "",
            "password": accountInfo["password"] ?? "",
            "phone_number": accountInfo["phone"] ?? "",
            "profile_pic": "",
            "sex": basicInfo["gender"] ?? "",
            "state": addressInfo["state"] ?? "",
            "status": "active",
            "street_address": addressInfo["street"] ?? "",
            "suffix": basicInfo["suffix"] ?? "",
            "user_id": userId,
            "user_role": "client",
            "username": accountInfo["username"] ?? "",
            "valid_id": clientInfo["idType"] ?? "",
            "zip_code": addressInfo["zip"] ?? ""
          });

          // Continue with your navigation or any other logic
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const FaceDetectionPage(),
          ));
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
