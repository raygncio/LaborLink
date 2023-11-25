import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/FilePickers/UploadFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';

const List<String> specializations = <String>[
  'Plumbing',
  'Carpentry',
  'Electrical',
  'Painting',
  'Maintenance',
  'Welding',
  'Housekeeping',
  'Roofing',
  'Installation',
  'Pest Control'
];

const List<String> validIds = <String>[
  'NBI',
  'PhilHealth',
  'SSS',
  'Postal ID',
];

class HandymanRequirementForm extends StatefulWidget {
  final GlobalKey<HandymanRequirementFormState> key;
  const HandymanRequirementForm({required this.key}) : super(key: key);

  @override
  State<HandymanRequirementForm> createState() =>
      HandymanRequirementFormState();
}

class HandymanRequirementFormState extends State<HandymanRequirementForm> {
  bool isAutoValidationEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _specializationController = TextEditingController();
  final _employerController = TextEditingController();
  final _idTypeController = TextEditingController();
  final _certificateNameController = TextEditingController();

  final _recLetterFilePickerKey = GlobalKey<UploadFilePickerState>();
  final _idFilePickerKey = GlobalKey<UploadFilePickerState>();
  final _certProofFilePickerKey = GlobalKey<UploadFilePickerState>();
  //final _nbiClearanceFilePickerKey = GlobalKey<UploadFilePickerState>();

  //file
  File? _recLetterImage;
  File? idFile;
  File? certProofFile;
  //File? nbiClearanceFile;

  // Style
  final _defaultBorder = Border.all(width: 1, color: AppColors.tertiaryBlue);
  final _errorBorder = Border.all(width: 1, color: AppColors.red);
  final _borderRadius = 5.0;
  final _labelTextStyle = getTextStyle(
      textColor: AppColors.tertiaryBlue,
      fontFamily: AppFonts.poppins,
      fontWeight: AppFontWeights.semiBold,
      fontSize: 11);
  final _inputTextStyle = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.regular,
      fontSize: 12);

  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  bool hasFile() {
    return _idFilePickerKey.currentState!.hasFile;
  }

  Map<String, dynamic> get getFormData {
    return {
      'specialization': _specializationController.text,
      'employer': _employerController.text,
      'idType': _idTypeController.text,
      'certificateName': _certificateNameController.text,
      'recLetterFile': _recLetterImage,
      'idFile': idFile,
      'certProofFile': certProofFile,
    };
  }

  @override
  void dispose() {
    _specializationController.dispose();
    _employerController.dispose();
    _idTypeController.dispose();
    _certificateNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.dirtyWhite,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
              offset: Offset(0, 4), blurRadius: 4, color: AppColors.blackShadow)
        ],
      ),
      child: Form(
          key: _formKey,
          autovalidateMode: isAutoValidationEnabled
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 18),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _specializationController.text.isNotEmpty
                                ? _specializationController.text
                                : specializations[0],
                            items: specializations.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _specializationController.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 12.0),
                              labelText: "SPECIALIZATION*",
                              labelStyle: _labelTextStyle,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                borderSide: const BorderSide(
                                    color: AppColors.tertiaryBlue, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                borderSide: const BorderSide(
                                    color: AppColors.tertiaryBlue, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                borderSide:
                                    BorderSide(color: AppColors.red, width: 1),
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                            ),
                            style: _inputTextStyle,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.5),
                            child: AppNormalTextFormField(
                              controller: _employerController,
                              height: 32,
                              label: "EMPLOYER",
                              labelTextStyle: _labelTextStyle,
                              defaultBorder: _defaultBorder,
                              errorBorder: _errorBorder,
                              borderRadius: _borderRadius,
                              inputTextStyle: _inputTextStyle,
                              fillColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.25),
                      child: UploadFilePicker(
                        key: _recLetterFilePickerKey,
                        label: "RECOMMENDATION LETTER",
                        onPickImage: (pickedImage) {
                          // receive image file
                          _recLetterImage = pickedImage;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.25),
                      child: DropdownButtonFormField<String>(
                        value: _idTypeController.text.isNotEmpty
                            ? _idTypeController.text
                            : validIds[0],
                        items: validIds.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value == 'nbi' ? value : null,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue!.toLowerCase() == 'nbi') {
                            setState(() {
                              _idTypeController.text = newValue.toLowerCase();
                            });
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 12.0,
                          ),
                          labelText: "CHOOSE TYPE OF VALID ID*",
                          labelStyle: _labelTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            borderSide: const BorderSide(
                              color: AppColors.tertiaryBlue,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            borderSide: const BorderSide(
                              color: AppColors.tertiaryBlue,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            borderSide:
                                BorderSide(color: AppColors.red, width: 1),
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                        ),
                        style: _inputTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.25),
                      child: UploadFilePicker(
                        key: _idFilePickerKey,
                        label: "ATTACH ID*",
                        onPickImage: (pickedImage) {
                          idFile = pickedImage;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 9.25),
                        child: AppNormalTextFormField(
                          controller: _certificateNameController,
                          height: 32,
                          label: "NAME OF CERTIFICATE*",
                          labelTextStyle: _labelTextStyle,
                          defaultBorder: _defaultBorder,
                          errorBorder: _errorBorder,
                          borderRadius: _borderRadius,
                          inputTextStyle: _inputTextStyle,
                          fillColor: AppColors.white,
                          validator: validateField,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.25),
                      child: UploadFilePicker(
                        key: _certProofFilePickerKey,
                        label: "ATTACH PROOF OF CERTIFICATION*",
                        onPickImage: (pickedImage) {
                          certProofFile = pickedImage;
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 9.25),
                    //   child: UploadFilePicker(
                    //     key: _nbiClearanceFilePickerKey,
                    //     label: "UPLOAD AN NBI CLEARANCE*",
                    //     onPickImage: (pickedImage) {
                    //       nbiClearanceFile = pickedImage;
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

String? validateField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "This field is required";
  }
  return null;
}
