import 'package:flutter/material.dart';

class TextAreaFormField extends StatefulWidget {
  final TextEditingController? controller;
  final double height;
  final String? label;
  final TextStyle? labelTextStyle;
  final EdgeInsetsGeometry? labelPadding;
  final TextStyle? inputTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final OutlineInputBorder? defaultBorder;
  final OutlineInputBorder? errorBorder;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? hintText;
  final TextStyle? hintTextStyle;

  const TextAreaFormField({
    Key? key,
    this.label,
    this.labelPadding,
    this.labelTextStyle,
    this.contentPadding,
    this.fillColor,
    this.validator,
    this.maxLength,
    this.hintText,
    this.hintTextStyle,
    required this.controller,
    required this.height,
    required this.inputTextStyle,
    required this.defaultBorder,
    required this.errorBorder,
  }) : super(key: key);

  @override
  State<TextAreaFormField> createState() => _TextAreaFormFieldState();
}

class _TextAreaFormFieldState extends State<TextAreaFormField> {
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
          child: TextFormField(
              controller: widget.controller,
              maxLines: widget.height ~/ 10,
              maxLength: widget.maxLength,
              style: widget.inputTextStyle,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: widget.hintTextStyle,
                  counter: const SizedBox.shrink(),
                  isDense: true,
                  filled: widget.fillColor != null,
                  fillColor: widget.fillColor,
                  contentPadding: widget.contentPadding,
                  focusedBorder: widget.defaultBorder,
                  enabledBorder: widget.defaultBorder,
                  errorBorder: widget.errorBorder,
                  errorStyle: const TextStyle(fontSize: 0, height: 0.1)),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: (value) => setState(() {}),
              validator: (value) {
                if (widget.validator != null) {
                  setState(() {
                    errorMessage = widget.validator!(value);
                  });
                  return errorMessage;
                }

                return null;
              }),
        ),
        Visibility(
          visible: widget.maxLength != null,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                  "${widget.controller!.text.length.toString()} / ${widget.maxLength}",
                  style: widget.inputTextStyle),
            ),
          ),
        )
      ],
    );
  }
}
