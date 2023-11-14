import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class ChooseFilePicker extends StatefulWidget {
  final String? label;
  final TextStyle? labelTextStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? containerBorderColor;
  final double? containerBorderRadius;
  final double? containerBorderWidth;
  final EdgeInsetsGeometry? containerPadding;
  final Color? buttonColor;
  final double? buttonBorderRadius;

  final GlobalKey<ChooseFilePickerState> key;

  const ChooseFilePicker({
    required this.key,
    this.label,
    this.labelPadding,
    this.labelTextStyle,
    this.containerBorderColor,
    this.containerBorderRadius,
    this.containerBorderWidth,
    this.containerPadding,
    this.buttonColor,
    this.buttonBorderRadius,
  }) : super(key: key);

  @override
  State<ChooseFilePicker> createState() => ChooseFilePickerState();
}

class ChooseFilePickerState extends State<ChooseFilePicker> {
  String _fileName = "";
  Color defaultColor = AppColors.secondaryBlue;
  double defaultBorderRadius = 8;

  String get getFileName => _fileName;

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
        Container(
          padding: widget.containerPadding ?? const EdgeInsets.all(4),
          height: 32,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                  widget.containerBorderRadius ?? defaultBorderRadius),
              border: Border.all(
                  color: widget.containerBorderColor ?? defaultColor,
                  width: widget.containerBorderWidth ?? 1)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilledButton(
                    onPressed: chooseFile,
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                widget.buttonBorderRadius ??
                                    defaultBorderRadius))),
                        backgroundColor: MaterialStateProperty.all(
                            widget.buttonColor ?? defaultColor),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(
                      "Choose File",
                      style: getTextStyle(
                          textColor: AppColors.white,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 10),
                    )),
              ),
              Expanded(
                child: Text(_fileName.isEmpty ? "No files chosen" : _fileName,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                        textColor: AppColors.black,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.regular,
                        fontSize: 10)),
              ),
            ],
          ),
        )
      ],
    );
  }

  void chooseFile() {
    setState(() {
      _fileName = "Test.png";
    });
  }
}
