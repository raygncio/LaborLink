import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:laborlink/Pages/Client/Home/SuccessPage.dart';
import 'package:laborlink/Pages/RatingsPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
// import 'package:laborlink/Widgets/Cards/OpenRequestCard.dart';
import 'package:laborlink/Widgets/FilePickers/ChooseFilePicker.dart';
import 'package:laborlink/Widgets/SuggestedFee.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/Widgets/FilePickers/UploadFilePicker.dart';
import 'package:laborlink/models/transaction.dart';
import 'package:laborlink/styles.dart';

Future<String?> confirmationDialog(BuildContext context) => showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.white,
          child: SizedBox(
            height: 101,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 57),
                  child: Text("Please review the details before proceeding",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                          textColor: AppColors.grey61,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.medium,
                          fontSize: 10)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 37),
                        child: SizedBox(
                          width: 94,
                          child: Row(
                            children: [
                              AppFilledButton(
                                  text: "Proceed",
                                  height: 27,
                                  fontSize: 10,
                                  fontFamily: AppFonts.montserrat,
                                  color: AppColors.accentOrange,
                                  command: () =>
                                      Navigator.of(context).pop("proceed"),
                                  borderRadius: 5),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 94,
                        child: Row(
                          children: [
                            AppFilledButton(
                                text: "Review",
                                height: 27,
                                fontSize: 10,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.secondaryBlue,
                                command: () =>
                                    Navigator.of(context).pop("review"),
                                borderRadius: 5),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) => value);

Future<void> errorDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.white,
        child: SizedBox(
          height: 226,
          child: Stack(
            children: [
              Positioned(
                  top: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                      "assets/icons/x-btn.png",
                      width: 11.57,
                      height: 11.57,
                    ),
                  )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/sad-face.png",
                      width: 75,
                      height: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9),
                      child: Text(
                        "Oh, no!",
                        style: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.medium,
                            fontSize: 20),
                      ),
                    ),
                    Text(
                      "Something went wrong",
                      style: getTextStyle(
                          textColor: AppColors.grey,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.medium,
                          fontSize: 15),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> suggestedFeeDialog(
        BuildContext context, Function(double) getFee) =>
    showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 25, bottom: 22),
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuggestedFee(
                  getFee: getFee,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 147,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        AppFilledButton(
                            text: "Submit",
                            padding: const EdgeInsets.only(top: 13),
                            fontSize: 15,
                            height: 35,
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.accentOrange,
                            command: () {
                              Navigator.of(context).pop('submit');
                            },
                            borderRadius: 8),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) => value);

Future<String?> makeOfferDialog(
  BuildContext context,
  Function(double) getFee,
  Function(String, File) getOfferData,
) {
  final filePickerKey = GlobalKey<ChooseFilePickerState>();
  final descriptionKey = GlobalKey<FormState>();
  final deviceHeight = MediaQuery.of(context).size.height;

  TextEditingController descriptionController = TextEditingController();

  _sendData() {
    // print('>>>>>>>>>${descriptionController.text}');
    String text;
    if (descriptionKey.currentState!.validate()) {
      File offerAttachment = filePickerKey.currentState!.getFile;
      text = descriptionController.text;
      getOfferData(text, offerAttachment);
    }
  }

  return showModalBottomSheet<String>(
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    builder: (context) {
      return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Form(
            key: descriptionKey,
            child: Container(
              height: isKeyboardVisible ? deviceHeight : 503,
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 25, bottom: 22),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // SUGGESTED FEE DIALOG
                    SuggestedFee(
                      getFee: getFee,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.75),
                      child: TextAreaFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 10),
                        controller: descriptionController,
                        height: 119,
                        inputTextStyle: getTextStyle(
                            textColor: AppColors.black,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.regular,
                            fontSize: 10),
                        hintText: "Description",
                        hintTextStyle: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.regular,
                            fontSize: 10),
                        defaultBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.grey, width: 0.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.red, width: 0.7),
                        ),
                      ),
                    ),
                    ChooseFilePicker(
                      key: filePickerKey,
                      label: "Attachment",
                      labelTextStyle: getTextStyle(
                          textColor: AppColors.accentOrange,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: 15),
                      buttonColor: AppColors.accentOrange,
                      containerBorderWidth: 0.7,
                      containerBorderColor: AppColors.grey,
                      buttonBorderRadius: 8,
                      containerPadding: const EdgeInsets.symmetric(
                          vertical: 4.71, horizontal: 6.18),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 147,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            AppFilledButton(
                                text: "Submit",
                                padding: const EdgeInsets.only(top: 18),
                                fontSize: 15,
                                height: 35,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.accentOrange,
                                borderRadius: 8,
                                command: () {
                                  _sendData();
                                  Navigator.of(context).pop("submit");
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String?> yesCancelDialog(BuildContext context, String prompt) =>
    showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.white,
          child: SizedBox(
            height: 101,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 57),
                  child: Text(prompt,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                          textColor: AppColors.grey61,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.medium,
                          fontSize: 10)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 37),
                        child: SizedBox(
                          width: 94,
                          child: Row(
                            children: [
                              AppFilledButton(
                                  text: "Yes",
                                  height: 27,
                                  fontSize: 10,
                                  fontFamily: AppFonts.montserrat,
                                  color: AppColors.accentOrange,
                                  command: () =>
                                      Navigator.of(context).pop("yes"),
                                  borderRadius: 5),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 94,
                        child: Row(
                          children: [
                            AppFilledButton(
                                text: "Cancel",
                                height: 27,
                                fontSize: 10,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.secondaryBlue,
                                command: () =>
                                    Navigator.of(context).pop("cancel"),
                                borderRadius: 5),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) => value);

Future<String?> attachServiceProofDialog(BuildContext context,
    Map<String, dynamic> clientDetails, String requestId) {
  final _filePickerKey = GlobalKey<UploadFilePickerState>();
  //file
  File? _selectedImage;

  return showModalBottomSheet<String>(
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    builder: (context) {
      return Container(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 22),
        height: 165,
        child: Column(
          children: [
            Text("Attach after service proof",
                style: getTextStyle(
                    textColor: AppColors.accentOrange,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 11)),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: UploadFilePicker(
                key: _filePickerKey,
                label: "Attachment",
                // labelStyle: getTextStyle(
                //     textColor: AppColors.accentOrange,
                //     fontFamily: AppFonts.montserrat,
                //     fontWeight: AppFontWeights.semiBold,
                //     fontSize: 15),
                // buttonColor: AppColors.accentOrange,
                // containerBorderWidth: 0.7,
                // containerBorderColor: AppColors.grey,
                // buttonBorderRadius: 8,
                // containerPadding: const EdgeInsets.symmetric(
                //     vertical: 4.71, horizontal: 6.18),
                onPickImage: (pickedImage) {
                  // receive image file
                  _selectedImage = pickedImage;
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 147,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    AppFilledButton(
                        text: "Submit",
                        padding: const EdgeInsets.only(top: 22),
                        fontSize: 15,
                        height: 35,
                        fontFamily: AppFonts.montserrat,
                        color: AppColors.accentOrange,
                        command: () async {
                          // upload the attachment link to the
                          try {
                            // Create a user in Firebase Authentication
                            DatabaseService service = DatabaseService();

                            String completionUrl =
                                await service.uploadReportAttachment(
                                    clientDetails['userId'], _selectedImage!);
                            await service.updateRequestCompletion(
                                requestId, completionUrl);

                            // Credit balance
                            Transaction? transactionData = await service
                                .parseTransactionDetails(requestId);
                            await service.addTransaction(transactionData!);
                          } catch (e) {
                            // Handle errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Error completing request"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => RatingsPage(
                              ratings: clientDetails,
                              user: 'handyman', requestId: requestId
                            ),
                          ));
                        },
                        borderRadius: 8),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  ).then((value) => value);
}
