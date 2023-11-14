import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/ReviewCard.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/Forms/RequestForm.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

class DirectRequestFormPage extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const DirectRequestFormPage({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<DirectRequestFormPage> createState() => _DirectRequestFormPageState();
}

class _DirectRequestFormPageState extends State<DirectRequestFormPage> {
  GlobalKey<RequestFormState> requestFormKey = GlobalKey<RequestFormState>();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(),
              Expanded(
                child: Container(
                  color: AppColors.white,
                  child: Stack(
                    children: [
                      formSection(),
                      HandymanInfoCard(handymanInfo: widget.handymanInfo),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  void onProceed() {
    if (requestFormKey.currentState!.validateForm()) {
      // Retrieve form data
      Map<String, dynamic> formData = requestFormKey.currentState!.getFormData;

      // Validate each field separately if needed
      String? titleError =
          requestFormKey.currentState!.validateTitle(formData['title']);
      String? descriptionError = requestFormKey.currentState!
          .validateDescription(formData['description']);
      String? addressError =
          requestFormKey.currentState!.validateAddress(formData['address']);

      if (titleError != null ||
          descriptionError != null ||
          addressError != null) {
        // Handle validation errors
        // Show error messages or perform actions accordingly
      } else {
        // Proceed with the form data
        // Your logic here...
        confirmationDialog(context).then((value) {
          if (value == null) return;

          if (value == "proceed") {
            suggestedFeeDialog(context).then((value) {
              if (value == null) return;

              if (value == "submit") {
                Navigator.of(context).pop("submit");
              }
            });
          }
        });
      }
    }
  }

  Widget appBar() => Padding(
        padding: const EdgeInsets.only(left: 26, bottom: 14, top: 34),
        child: GestureDetector(
          onTap: onBack,
          child:
              Image.asset("assets/icons/back-btn.png", height: 13, width: 17.5),
        ),
      );

  Widget formSection() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 94, left: 24, right: 24, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequestForm(
                key: requestFormKey,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    AppFilledButton(
                        text: "Proceed",
                        height: 37,
                        fontSize: 15,
                        fontFamily: AppFonts.montserrat,
                        color: AppColors.secondaryBlue,
                        command: onProceed,
                        borderRadius: 8),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
