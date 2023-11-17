import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class BasicInformationForm extends StatefulWidget {
  final GlobalKey<BasicInformationFormState> key;
  const BasicInformationForm({required this.key}) : super(key: key);

  @override
  State<BasicInformationForm> createState() => BasicInformationFormState();
}

class BasicInformationFormState extends State<BasicInformationForm> {
  bool isAutoValidationEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _birthdayMonthController = TextEditingController();
  final _birthdayDayController = TextEditingController();
  final _birthdayYearController = TextEditingController();
  final _genderController = TextEditingController();
  DateTime? _selectedDate;

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

  Map<String, dynamic> get getFormData {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String middleName = _middleNameController.text;
    String suffix = _suffixController.text;
    String gender = _genderController.text;

    return {
      "first_name": firstName,
      "last_name": lastName,
      "middle_name": middleName,
      "suffix": suffix,
      "birthday": _selectedDate,
      "gender": gender
    };
  }

  // date picker

  void _presentDatePicker() async {
    final now = DateTime.now(); // initial date
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final lastDate = DateTime(now.year - 18, now.month, now.day);
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _suffixController.dispose();
    _birthdayMonthController.dispose();
    _birthdayDayController.dispose();
    _birthdayYearController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  /*void printUserInputs() {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String middleName = _middleNameController.text;
    String suffix = _suffixController.text;
    String birthdayMonth = _birthdayMonthController.text;
    String birthdayDay = _birthdayDayController.text;
    String birthdayYear = _birthdayYearController.text;

    print('User Inputs:');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Middle Name: $middleName');
    print('Suffix: $suffix');
    print('Birthday: $birthdayMonth/$birthdayDay/$birthdayYear');
  }*/

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 3.5),
                        child: AppNormalTextFormField(
                          controller: _firstNameController,
                          height: 32,
                          label: "FIRST NAME*",
                          labelTextStyle: _labelTextStyle,
                          defaultBorder: _defaultBorder,
                          errorBorder: _errorBorder,
                          borderRadius: _borderRadius,
                          inputTextStyle: _inputTextStyle,
                          fillColor: AppColors.white,
                          validator: validateField,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.5),
                        child: AppNormalTextFormField(
                          controller: _lastNameController,
                          height: 32,
                          label: "LAST NAME*",
                          labelTextStyle: _labelTextStyle,
                          defaultBorder: _defaultBorder,
                          errorBorder: _errorBorder,
                          borderRadius: _borderRadius,
                          inputTextStyle: _inputTextStyle,
                          fillColor: AppColors.white,
                          validator: validateField,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9.25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.5),
                          child: AppNormalTextFormField(
                            controller: _middleNameController,
                            height: 32,
                            label: "MIDDLE NAME",
                            labelTextStyle: _labelTextStyle,
                            defaultBorder: _defaultBorder,
                            errorBorder: _errorBorder,
                            borderRadius: _borderRadius,
                            inputTextStyle: _inputTextStyle,
                            fillColor: AppColors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.5),
                          child: AppNormalTextFormField(
                            controller: _suffixController,
                            height: 32,
                            label: "SUFFIX",
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9.25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BIRTHDATE (MM/DD/YY)*",
                              style: getTextStyle(
                                  textColor: AppColors.tertiaryBlue,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: 11),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 3.5),
                                      child: Text(
                                        _selectedDate == null
                                            ? 'No date selected'
                                            : formatter.format(_selectedDate!),
                                        style: getTextStyle(
                                            textColor: AppColors.tertiaryBlue,
                                            fontFamily: AppFonts.poppins,
                                            fontWeight: AppFontWeights.semiBold,
                                            fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 3.5),
                                      child: IconButton(
                                          onPressed: _presentDatePicker,
                                          icon: const Icon(
                                            Icons.calendar_month,
                                            color: AppColors.tertiaryBlue,
                                          )),
                                    ),
                                  ),

                                  /*
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3.5),
                                child: AppNormalTextFormField(
                                  controller: _birthdayMonthController,
                                  height: 32,
                                  defaultBorder: _defaultBorder,
                                  errorBorder: _errorBorder,
                                  borderRadius: _borderRadius,
                                  inputTextStyle: _inputTextStyle,
                                  fillColor: AppColors.white,
                                  validator: validateField,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 3.5, left: 3.5),
                                child: AppNormalTextFormField(
                                  controller: _birthdayDayController,
                                  height: 32,
                                  defaultBorder: _defaultBorder,
                                  errorBorder: _errorBorder,
                                  borderRadius: _borderRadius,
                                  inputTextStyle: _inputTextStyle,
                                  fillColor: AppColors.white,
                                  validator: validateField,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.5),
                                child: AppNormalTextFormField(
                                  controller: _birthdayYearController,
                                  height: 32,
                                  defaultBorder: _defaultBorder,
                                  errorBorder: _errorBorder,
                                  borderRadius: _borderRadius,
                                  inputTextStyle: _inputTextStyle,
                                  fillColor: AppColors.white,
                                  validator: validateField,
                                ),
                              ),
                            ),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.5),
                          child: AppNormalTextFormField(
                            controller: _genderController,
                            height: 32,
                            label: "GENDER",
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
                )
              ],
            ),
          )),
    );
  }

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }
}
