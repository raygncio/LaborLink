import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class UploadFilePicker extends StatefulWidget {
  final label;

  final GlobalKey<UploadFilePickerState> key;

  const UploadFilePicker({required this.key, required this.label})
      : super(key: key);

  @override
  State<UploadFilePicker> createState() => UploadFilePickerState();
}

class UploadFilePickerState extends State<UploadFilePicker> {
  String _fileName = "";

  String get getFileName => _fileName;
  bool get hasFile => _fileName.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
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
                    onPressed: uploadFile,
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

  void uploadFile() {
    setState(() {
      _fileName = "Test.png";
    });
  }
}
