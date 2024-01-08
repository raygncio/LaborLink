import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Report/ReportSubmittedPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/FilePickers/UploadFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laborlink/models/report.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/providers/current_user_provider.dart';

final _firebase = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
DatabaseService service = DatabaseService();

// class ReportIssuePage extends StatefulWidget {
//   final String userId;
//   const ReportIssuePage({Key? key, required this.userId}) : super(key: key);

//   @override
//   State<ReportIssuePage> createState() => _ReportIssuePageState();
// }

// get the user id

class ReportIssuePage extends ConsumerWidget {
  ReportIssuePage({super.key});

  final _descriptionController = TextEditingController();
  final _filePickerKey = GlobalKey<UploadFilePickerState>();

  //file
  File? _selectedImage;
  late String userId;

  final _labelTextStyle = getTextStyle(
      textColor: AppColors.secondaryBlue,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.semiBold,
      fontSize: 15);

  // @override
  // void dispose() {
  //   _descriptionController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('>>>>>>>>>>>>report an issue');
    ref.read(currentUserProvider.notifier).saveCurrentUserInfo();

    Map<String, dynamic> userInfo = ref.watch(currentUserProvider);
    userId = userInfo['userId'];
    final deviceWidth = MediaQuery.of(context).size.width;

    print('>>>>>>>>>>>>report an issue return');
    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          color: AppColors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 74),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          "Clear the path for improvements",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: FontWeight.w900,
                              fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 27, right: 26, top: 30),
                        child: Text(
                            "Tell us about the issue you have encountered during your service, and we will help you resolve it right away!",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.medium,
                                fontSize: 15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 26),
                              child: TextAreaFormField(
                                controller: _descriptionController,
                                height: 215,
                                inputTextStyle: getTextStyle(
                                    textColor: AppColors.black,
                                    fontFamily: AppFonts.montserrat,
                                    fontWeight: AppFontWeights.regular,
                                    fontSize: 12),
                                defaultBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.secondaryBlue,
                                      width: 0.7),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.red, width: 0.7),
                                ),
                                label: "Description",
                                labelTextStyle: _labelTextStyle,
                                maxLength: 500,
                                validator: validateField,
                              ),
                            ),
                            UploadFilePicker(
                              key: _filePickerKey,
                              label: "Attachment",
                              onPickImage: (pickedImage) {
                                // receive image file
                                _selectedImage = pickedImage;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 43),
                                child: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      AppFilledButton(
                                          text: "Submit",
                                          fontSize: 16,
                                          fontFamily: AppFonts.montserrat,
                                          color: AppColors.accentOrange,
                                          command: () => onSubmit(context),
                                          borderRadius: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: appBar(deviceWidth, context)),
            ],
          ),
        ),
      ),
    );
  }

  void onBack(BuildContext context) => Navigator.of(context).pop();

  void onSubmit(BuildContext context) async {
    String? descriptionError = validateField(_descriptionController.text);

    if (descriptionError != null) {
      // Handle the validation error for the description field
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(descriptionError),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      try {
        // Create a user in Firebase Authentication
        DatabaseService service = DatabaseService();

        String reportUrl =
            await service.uploadReportAttachment(userId, _selectedImage!);

        Report report = Report(
            issue: _descriptionController.text,
            proof: reportUrl,
            status: "waiting",
            userId: userId);

        await service.addReports(report);
        // Continue with your navigation or any other logic
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ReportSubmittedPage(),
          ),
        );
      } catch (e) {
        // Handle errors during user creation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error creating user"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget appBar(deviceWidth, context) => Container(
        color: AppColors.secondaryBlue,
        height: 74,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              height: 23,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () => onBack(context),
                        child: Image.asset("assets/icons/back-btn-2.png",
                            height: 23,
                            width: 13,
                            alignment: Alignment.centerLeft),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Report an issue",
                      style: getTextStyle(
                          textColor: AppColors.secondaryYellow,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please provide a detailed description of the issue you encountered.";
    }
    return null;
  }
}
