import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/FilePickers/UploadFilePicker.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<LoginFormState> key;
  const LoginForm({required this.key}) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool obscureText = true;

  // Style
  final _defaultBorder = Border.all(width: 1, color: AppColors.accentOrange);
  final _errorBorder = Border.all(width: 1, color: AppColors.red);
  final _borderRadius = 5.0;
  final _labelTextStyle = getTextStyle(
      textColor: AppColors.accentOrange,
      fontFamily: AppFonts.poppins,
      fontWeight: AppFontWeights.bold,
      fontSize: 12);
  final _inputTextStyle = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.regular,
      fontSize: 12);

  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  Map<String, dynamic> get getFormData {
    return {
      "username": _usernameEmailController.text,
      "password": _passwordController.text,
    };
  }

  @override
  void dispose() {
    _usernameEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNormalTextFormField(
              controller: _usernameEmailController,
              height: 42,
              contentPadding: const EdgeInsets.only(
                  left: 12, right: 12, top: 13, bottom: 15),
              label: "Username or E-mail",
              labelTextStyle: _labelTextStyle,
              defaultBorder: _defaultBorder,
              errorBorder: _errorBorder,
              borderRadius: _borderRadius,
              inputTextStyle: _inputTextStyle,
              fillColor: AppColors.white,
              suffixIcon: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: AppColors.accentOrange,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: AppNormalTextFormField(
                obscureText: true,
                controller: _passwordController,
                height: 42,
                contentPadding: const EdgeInsets.only(
                    left: 12, right: 12, top: 13, bottom: 15),
                label: "Password",
                labelTextStyle: _labelTextStyle,
                defaultBorder: _defaultBorder,
                errorBorder: _errorBorder,
                borderRadius: _borderRadius,
                inputTextStyle: _inputTextStyle,
                fillColor: AppColors.white,
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.lock,
                    size: 14,
                    color: AppColors.accentOrange,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
