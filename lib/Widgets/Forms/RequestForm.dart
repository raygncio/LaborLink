import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Checkbox.dart';
import 'package:laborlink/Widgets/Dropdown.dart';
import 'package:laborlink/Widgets/FilePickers/ChooseFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/styles.dart';

import '../../dummyDatas.dart';

class RequestForm extends StatefulWidget {
  final GlobalKey<RequestFormState> key;

  const RequestForm({required this.key}) : super(key: key);

  @override
  State<RequestForm> createState() => RequestFormState();
}

class RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();

  final _filePickerKey = GlobalKey<ChooseFilePickerState>();

  final List<String> _categories = dummyDropdownData;
  final List<String> _dateOptions = dummyDropdownData;
  final List<String> _timeOptions = dummyDropdownData;

  String _categoryValue = "";
  String _dateValue = "";
  String _timeValue = "";
  bool _useDefaultAddress = false;

  // Style
  final _defaultBorder = Border.all(width: 0.7, color: AppColors.secondaryBlue);
  final _errorBorder = Border.all(width: 0.7, color: AppColors.red);
  final _borderRadius = 8.0;
  final _labelTextStyle = getTextStyle(
      textColor: AppColors.secondaryBlue,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.semiBold,
      fontSize: 10);
  final _inputTextStyle = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.regular,
      fontSize: 10);

  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  Map<String, dynamic> get getFormData {
    setState(() {});
    return {
      "title": _titleController.text,
      "category": _categoryValue,
      "description": _descriptionController.text,
      "attachment": _filePickerKey.currentState!.getFileName,
      "date": _dateValue,
      "time": _timeValue,
      "address": _addressController.text,
      "instructions": _instructionsController.text,
    };
  }

  @override
  void initState() {
    _categoryValue = _categories.first;
    _dateValue = _dateOptions.first;
    _timeValue = _timeOptions.first;

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: AppNormalTextFormField(
                    controller: _titleController,
                    height: 27,
                    label: "Title *",
                    labelTextStyle: _labelTextStyle,
                    defaultBorder: _defaultBorder,
                    errorBorder: _errorBorder,
                    borderRadius: _borderRadius,
                    inputTextStyle: _inputTextStyle,
                    fillColor: AppColors.white,
                    validator: validateTitle,
                  ),
                ),
              ),
              AppDropdown(
                height: 27,
                width: 110,
                label: "Category *",
                labelTextStyle: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.semiBold,
                    fontSize: 10),
                labelPadding: const EdgeInsets.only(bottom: 4),
                dropdownValues: _categories,
                onChanged: (value) {
                  setState(() {
                    _categoryValue = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: TextAreaFormField(
                label: "Description *",
                validator: validateDescription,
                labelPadding: const EdgeInsets.only(bottom: 4),
                labelTextStyle: _labelTextStyle,
                controller: _descriptionController,
                height: 76,
                maxLength: 500,
                contentPadding: const EdgeInsets.all(6),
                inputTextStyle: _inputTextStyle,
                defaultBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: AppColors.secondaryBlue, width: 0.7),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.red, width: 0.7),
                )),
          ),
          SizedBox(
            width: 202,
            child: ChooseFilePicker(
              key: _filePickerKey,
              label: "Attachment",
              labelTextStyle: _labelTextStyle,
              containerBorderWidth: 0.7,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppDropdown(
                    height: 27,
                    width: 113,
                    label: "Date needed *",
                    labelTextStyle: getTextStyle(
                        textColor: AppColors.secondaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 10),
                    labelPadding: const EdgeInsets.only(bottom: 4),
                    dropdownValues: _dateOptions,
                    onChanged: (value) {
                      setState(() {
                        _dateValue = value;
                      });
                    },
                  ),
                ),
                AppDropdown(
                  height: 27,
                  width: 113,
                  label: "Time needed *",
                  labelTextStyle: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 10),
                  labelPadding: const EdgeInsets.only(bottom: 4),
                  dropdownValues: _timeOptions,
                  onChanged: (value) {
                    setState(() {
                      _timeValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppNormalTextFormField(
                    controller: _addressController,
                    height: 27,
                    label: "Address *",
                    labelTextStyle: _labelTextStyle,
                    defaultBorder: _defaultBorder,
                    errorBorder: _errorBorder,
                    borderRadius: _borderRadius,
                    inputTextStyle: _inputTextStyle,
                    fillColor: AppColors.white,
                    validator: validateAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 11.5),
                  child: AppCheckBox(
                    label: "Use\nhome address",
                    labelStyle: getTextStyle(
                        textColor: AppColors.secondaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 7),
                    checkboxColor: AppColors.secondaryBlue,
                    borderRadius: 5,
                    borderWidth: 1,
                    onChanged: (value) {
                      setState(() {
                        _useDefaultAddress = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              children: [
                Expanded(
                  child: AppNormalTextFormField(
                    controller: _instructionsController,
                    height: 27,
                    label: "Instructions",
                    labelTextStyle: _labelTextStyle,
                    defaultBorder: _defaultBorder,
                    errorBorder: _errorBorder,
                    borderRadius: _borderRadius,
                    inputTextStyle: _inputTextStyle,
                    fillColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Title is required";
    }

    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Address is required";
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }
}
