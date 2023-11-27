import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Checkbox.dart';
import 'package:laborlink/Widgets/Dropdown.dart';
import 'package:laborlink/Widgets/FilePickers/UploadFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'package:intl/intl.dart';
import '../../dummyDatas.dart';

final _firebase = FirebaseAuth.instance;
final formatter = DateFormat.yMd();

// const List<String> specializations = <String>[
//   'Plumbing',
//   'Carpentry',
//   'Electrical',
//   'Painting',
//   'Maintenance',
//   'Welding',
//   'Housekeeping',
//   'Roofing',
//   'Installation',
//   'Pest Control'
// ];

class RequestForm extends StatefulWidget {
  final String userId;
  final GlobalKey<RequestFormState> key;
  final Map<String, dynamic>? handymanInfo;
  const RequestForm(
      {required this.key, required this.userId, this.handymanInfo})
      : super(key: key);

  @override
  State<RequestForm> createState() => RequestFormState();
}

class RequestFormState extends State<RequestForm> {
  bool isAutoValidationEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();

  final _filePickerKey = GlobalKey<UploadFilePickerState>();

//file
  File? _selectedImage;
  DateTime? _selectedDate;
  String homeAddress = '';
  var formattedDate = DateFormat('d-MM-yyyy');

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
    return _formKey.currentState!.validate() ||
        _selectedDate != null ||
        _selectedImage != null;
  }

  bool hasFile() {
    return _filePickerKey.currentState!.hasFile;
  }

  Map<String, dynamic> get getFormData {
    if (widget.handymanInfo != null) {
      print(_timeValue);
      return {
        "title": _titleController.text,
        "category": _categoryValue,
        "description": _descriptionController.text,
        "attachment": _selectedImage,
        "date": formattedDate.format(_selectedDate!),
        "time": _timeValue,
        "address": _addressController.text,
        "instructions": _instructionsController.text,
        "handymanId": widget.handymanInfo!["handymanId"],
      };
    } else {
      return {
        "title": _titleController.text,
        "category": _categoryValue,
        "description": _descriptionController.text,
        "attachment": _selectedImage,
        "date": formattedDate.format(_selectedDate!),
        "time": _timeValue,
        "address": _addressController.text,
        "instructions": _instructionsController.text,
      };
    }
  }

  Future<void> fetchUserAddress() async {
    DatabaseService service = DatabaseService();
    try {
      Client clientInfo = await service.getUserData(widget.userId);

      homeAddress = clientInfo.streetAddress;
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  void initState() {
    _categoryValue = widget.handymanInfo != null
        ? widget.handymanInfo!['specialization']
        : _categories.first;
    print('>>>>>>>>>>>>>>$_categoryValue');
    _dateValue = _dateOptions.first;
    _timeValue = _timeOptions.first;

    super.initState();
    fetchUserAddress();
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
      autovalidateMode: isAutoValidationEnabled
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
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
                dropdownValues: specializations,
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
            child: UploadFilePicker(
              key: _filePickerKey,
              label: "Attachment",
              onPickImage: (pickedImage) {
                // receive image file
                setState(() {
                  _selectedImage = pickedImage;
                });
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: _presentDatePicker,
                  icon: const Icon(
                    Icons.calendar_today,
                    color: AppColors.tertiaryBlue,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10),
                child: Text(
                  _selectedDate != null
                      ? formattedDate.format(_selectedDate!)
                      : 'Please select a date',
                  style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 15,
                  ),
                ),
              ),
              const Spacer(),
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
                dropdownValues: timeOptions,
                onChanged: (value) {
                  setState(() {
                    _timeValue = value;
                  });
                },
              ),
            ],
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
                        _addressController.text = homeAddress;
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

  void _presentDatePicker() async {
    final now = DateTime.now(); // initial date
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year, now.month, now.day + 2);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // this line will be executed after selecting date
    setState(() {
      _selectedDate = pickedDate;
    });
  }
}
