import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/FilePickers/UploadFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';

const List<String> validIds = <String>[
  'NBI',
  'PhilHealth',
  'SSS',
  'Postal ID',
];

class ClientRequirementForm extends StatefulWidget {
  final GlobalKey<ClientRequirementFormState> key;
  const ClientRequirementForm({required this.key}) : super(key: key);

  @override
  State<ClientRequirementForm> createState() => ClientRequirementFormState();
}

class ClientRequirementFormState extends State<ClientRequirementForm> {
  bool isAutoValidationEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _idTypeController = TextEditingController();

  //file
  File? _selectedImage;

  final _idFilePickerKey = GlobalKey<UploadFilePickerState>();

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
      "idType": _idTypeController.text,
      "idFile": _selectedImage,
    };
  }

  @override
  void dispose() {
    _idTypeController.dispose();
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
              const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 15),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: validIds.contains(_idTypeController.text)
                    ? _idTypeController.text
                    : validIds[0],
                items: validIds.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    enabled: value == 'NBI',
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _idTypeController.text = newValue!.toLowerCase();
                  });
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
                    borderSide: BorderSide(color: AppColors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                style: _inputTextStyle.copyWith(fontSize: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.25),
                child: UploadFilePicker(
                  key: _idFilePickerKey,
                  label: "ATTACH FILE*",
                  onPickImage: (pickedImage) {
                    // receive image file
                    _selectedImage = pickedImage;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }
}
