import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';

class AddressForm extends StatefulWidget {
  final GlobalKey<AddressFormState> key;
  const AddressForm({required this.key}) : super(key: key);

  @override
  State<AddressForm> createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  bool isAutoValidationEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _streetAddressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipcodeController = TextEditingController();

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
    String street = _streetAddressController.text;
    String state = _stateController.text;
    String city = _cityController.text;
    String zip = _zipcodeController.text;

    return {
      "street": street,
      "state": state,
      "city": city,
      "zip": zip,
    };
  }

  @override
  void dispose() {
    _streetAddressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;

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
                  controller: _streetAddressController,
                  height: 32,
                  label: "STREET ADDRESS*",
                  labelTextStyle: _labelTextStyle,
                  defaultBorder: _defaultBorder,
                  errorBorder: _errorBorder,
                  borderRadius: _borderRadius,
                  inputTextStyle: _inputTextStyle,
                  fillColor: AppColors.white,
                  validator: validateField,
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
                            controller: _stateController,
                            height: 32,
                            label: "REGION*",
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
                          padding: const EdgeInsets.only(right: 3.5, left: 3.5),
                          child: AppNormalTextFormField(
                            controller: _cityController,
                            height: 32,
                            label: "CITY*",
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
                            controller: _zipcodeController,
                            height: 32,
                            label: "ZIP CODE*",
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
