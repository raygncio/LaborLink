import 'package:flutter/material.dart';
// import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class PhoneFormField extends StatefulWidget {
  final TextEditingController? controller;
  final double height;
  final String? label;
  final String? prefix;
  final TextStyle? labelTextStyle;
  final EdgeInsetsGeometry? labelPadding;
  final TextStyle? inputTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Border? defaultBorder;
  final Border? errorBorder;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextAlign? textAlign;
  final Function(String?)? onChanged;

  const PhoneFormField({
    Key? key,
    this.prefix,
    this.label,
    this.labelPadding,
    this.contentPadding,
    this.fillColor,
    this.validator,
    this.labelTextStyle,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.hintTextStyle,
    this.onChanged,
    this.textAlign,
    required this.borderRadius,
    required this.controller,
    required this.height,
    required this.inputTextStyle,
    required this.defaultBorder,
    required this.errorBorder,
  }) : super(key: key);

  @override
  State<PhoneFormField> createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.label != null,
          child: Padding(
            padding: widget.labelPadding ?? const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.label ?? "",
              style: widget.labelTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.fillColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.borderRadius)),
                  border: errorMessage == null
                      ? widget.defaultBorder
                      : widget.errorBorder,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: widget.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Container(
                        child: widget.prefixIcon,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.controller,
                          obscureText: widget.obscureText ?? false,
                          style: widget.inputTextStyle,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textAlign: widget.textAlign ?? TextAlign.start,
                          decoration: InputDecoration(
                              prefixText: widget.prefix,
                              hintText: widget.hintText,
                              hintStyle: widget.hintTextStyle,
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              errorStyle:
                                  const TextStyle(fontSize: 0, height: 0.1)),
                          onChanged: widget.onChanged,
                          validator: (value) {
                            if (widget.validator != null) {
                              setState(() {
                                errorMessage = widget.validator!(value);
                              });
                              return errorMessage;
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        child: widget.suffixIcon,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Visibility(
            visible: errorMessage != null && widget.validator != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorMessage ?? "",
                style: getTextStyle(
                    textColor: AppColors.red,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 10),
              ),
            )),
      ],
    );
  }
}
