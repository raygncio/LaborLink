import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Report/ReportSubmittedPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/FilePickers/ChooseFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/styles.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({Key? key}) : super(key: key);

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _descriptionController = TextEditingController();
  final _filePickerKey = GlobalKey<ChooseFilePickerState>();

  final _labelTextStyle = getTextStyle(
      textColor: AppColors.secondaryBlue,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.semiBold,
      fontSize: 15);

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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
                              fontWeight: AppFontWeights.bold,
                              fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 17, top: 5, bottom: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("Request ID: 12345",
                              style: getTextStyle(
                                  textColor: AppColors.white,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: AppFontWeights.bold,
                                  fontSize: 16)),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 27, right: 26, top: 16),
                        child: Text(
                            "Tell us about the issue you have encountered during your service, and we will help you resolve it right away!",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
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
                              ),
                            ),
                            ChooseFilePicker(
                              key: _filePickerKey,
                              label: "Attachment",
                              labelTextStyle: _labelTextStyle,
                              containerBorderWidth: 0.7,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 43),
                                child: SizedBox(
                                  width: 127,
                                  child: Row(
                                    children: [
                                      AppFilledButton(
                                          text: "Submit",
                                          fontSize: 15,
                                          fontFamily: AppFonts.montserrat,
                                          color: AppColors.accentOrange,
                                          command: onSubmit,
                                          borderRadius: 5),
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
              Align(alignment: Alignment.topCenter, child: appBar(deviceWidth)),
            ],
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  void onSubmit() => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ReportSubmittedPage(),
      ));

  Widget appBar(deviceWidth) => Container(
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
                        onTap: onBack,
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
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
