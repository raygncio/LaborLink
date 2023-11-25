import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  //final void Function(File pickedImage) onPickImage;
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
    //required this.onPickImage,
  }) : super(key: key);

  @override
  State<ChooseFilePicker> createState() => ChooseFilePickerState();
}

class ChooseFilePickerState extends State<ChooseFilePicker> {
  String _fileName = "";
  Color defaultColor = AppColors.secondaryBlue;
  double defaultBorderRadius = 8;

  File? _pickedImageFile;
  String get getFileName => _fileName;

  String? validateAttachment() {
    if (_pickedImageFile == null) {
      return 'Please upload a file.';
    }
    return null;
  }

  void _pickImage() async {
    // image quality -> 50 for small fize
    // max width: 150 -> small frame
    // -> lower bandwidth
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 180);

    // check if there's an image
    if (pickedImage == null) return;

    // stores and updates image preview
    // setState(() {
    //   // creates a File object based on the path of the XFile image
    //   _pickedImageFile = File(pickedImage.path);
    // });

    setState(() {
      _pickedImageFile = File(pickedImage.path);
      _fileName = pickedImage.path;
    });

    // pass image file between screen
    // widget.onPickImage(_pickedImageFile!);
  }

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
                    onPressed: _pickImage,
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
                        fontSize: 12)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
