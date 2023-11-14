import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/ReviewCard.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

class ViewHandymanProfile extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const ViewHandymanProfile({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<ViewHandymanProfile> createState() => _ViewHandymanProfileState();
}

class _ViewHandymanProfileState extends State<ViewHandymanProfile> {

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(),
              Expanded(
                child: Container(
                  color: AppColors.dirtyWhite,
                  child: Stack(
                    children: [
                      reviewsSection(),
                      HandymanInfoCard(handymanInfo: widget.handymanInfo),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Padding(
        padding: const EdgeInsets.only(left: 26, bottom: 14, top: 34),
        child: GestureDetector(
          onTap: onBack,
          child:  Image.asset("assets/icons/back-btn.png", height: 13, width: 17.5),
        ),
      );

  Widget reviewsSection() => SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Padding(
      padding: const EdgeInsets.only(top: 94, left: 10, right: 10, bottom: 10),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dummyReviews.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> currentReview = dummyReviews[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: ReviewCard(
                          rate: currentReview["rating"],
                          date: currentReview["date"],
                          reviewerName: currentReview["name"],
                          review: currentReview["review"],
                          reviewerImgUrl: currentReview["img_url"]),
                    );
                  },
                ),
              ),
            ],
          ),
    ),
  );
}
