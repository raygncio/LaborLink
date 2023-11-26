import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UploadFilePicker extends StatefulWidget {
  final label;

  final GlobalKey<UploadFilePickerState> key;
  final void Function(File pickedImage)? onPickImage;

  const UploadFilePicker({required this.key, this.label, this.onPickImage})
      : super(key: key);

  @override
  State<UploadFilePicker> createState() => UploadFilePickerState();
}

class UploadFilePickerState extends State<UploadFilePicker> {
  String _fileName = "";
  File? _pickedImageFile;

  String get getFileName => _fileName;
  bool get hasFile => _fileName.isNotEmpty;

  void _uploadFile() async {
    // image quality -> 50 for small fize
    // max width: 150 -> small frame
    // -> lower bandwidth
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    // check if there's an image
    if (pickedImage == null) return;

    // stores and updates image preview
    setState(() {
      // creates a File object based on the path of the XFile image
      _pickedImageFile = File(pickedImage.path);
      _fileName = basename(pickedImage.path);
    });

    // pass image file between screen
    widget.onPickImage!(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? '',
          style: getTextStyle(
              textColor: AppColors.tertiaryBlue,
              fontFamily: AppFonts.poppins,
              fontWeight: AppFontWeights.semiBold,
              fontSize: 11),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            height: 32,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.tertiaryBlue)),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(_fileName,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                            textColor: AppColors.black,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.regular,
                            fontSize: 10)),
                  ),
                ),
                FilledButton(
                    onPressed: _uploadFile,
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.tertiaryBlue),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(
                      "UPLOAD FILE",
                      style: getTextStyle(
                          textColor: AppColors.white,
                          fontFamily: AppFonts.poppins,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 8),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
