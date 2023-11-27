import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReviewCard extends StatefulWidget {
  final int rate;
  final String date;
  final String reviewerName;
  final String review;

  const ReviewCard({
    Key? key,
    required this.rate,
    required this.date,
    required this.reviewerName,
    required this.review,
  }) : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  File? defaultAvatar;

  @override
  void initState() {
    super.initState();
    // Call an async function to fetch data
    _loadDefaultAvatar();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  _loadDefaultAvatar() async {
    defaultAvatar =
        await getImageFileFromAssets('icons/person-circle-blue.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 11, right: 13, top: 9, bottom: 9),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: RateWidget(rate: widget.rate, iconSize: 15),
              ),
              Text(
                widget.date,
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 7),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Text(
                  widget.reviewerName,
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 10),
                ),
              ),
              ClipOval(
                child: Image.file(
                  defaultAvatar!,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Text(
              widget.review,
              overflow: TextOverflow.visible,
              style: getTextStyle(
                  textColor: AppColors.black,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
