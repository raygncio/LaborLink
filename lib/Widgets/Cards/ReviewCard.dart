import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';

class ReviewCard extends StatefulWidget {
  final int rate;
  final String date;
  final String reviewerName;
  final String review;
  final String reviewerImgUrl;

  const ReviewCard(
      {Key? key,
      required this.rate,
      required this.date,
      required this.reviewerName,
      required this.review,
      required this.reviewerImgUrl})
      : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
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
                  child: Image.network(
                widget.reviewerImgUrl,
                width: 20,
                height: 20,
              )),
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
