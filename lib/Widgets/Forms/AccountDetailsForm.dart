import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';

class AccountDetailsForm extends StatefulWidget {
  final GlobalKey<AccountDetailsFormState> key;
  const AccountDetailsForm({required this.key}) : super(key: key);

  @override
  State<AccountDetailsForm> createState() => AccountDetailsFormState();
}

class AccountDetailsFormState extends State<AccountDetailsForm> {
  bool isAutoValidationEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _emailAddressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

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
    String email = _emailAddressController.text;
    String username = _usernameController.text;
    String phone = _phoneNumberController.text;
    String password = _passwordController.text;

    return {
      "email": email,
      "username": username,
      "phone": phone,
      "password": password,
    };
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
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
                AppNormalTextFormField(
                  controller: _emailAddressController,
                  height: 32,
                  label: "EMAIL ADDRESS*",
                  labelTextStyle: _labelTextStyle,
                  defaultBorder: _defaultBorder,
                  errorBorder: _errorBorder,
                  borderRadius: _borderRadius,
                  inputTextStyle: _inputTextStyle,
                  fillColor: AppColors.white,
                  validator: validateEmailAddress,
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
                            controller: _usernameController,
                            height: 32,
                            label: "USERNAME*",
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
                            controller: _phoneNumberController,
                            height: 32,
                            label: "PHONE NUMBER*",
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9.25),
                  child: AppNormalTextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    height: 32,
                    label: "PASSWORD*",
                    labelTextStyle: _labelTextStyle,
                    defaultBorder: _defaultBorder,
                    errorBorder: _errorBorder,
                    borderRadius: _borderRadius,
                    inputTextStyle: _inputTextStyle,
                    fillColor: AppColors.white,
                    validator: validateField,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String? validateEmailAddress(String? value) {
    if (value == null || value.trim().isEmpty || !value.contains('@')) {
      return "Email Address is required";
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
