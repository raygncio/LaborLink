import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Cards/RequestCard.dart';
import 'package:laborlink/styles.dart';

class ReviewedRequestsPage extends StatefulWidget {
  const ReviewedRequestsPage({Key? key}) : super(key: key);

  @override
  State<ReviewedRequestsPage> createState() => _ReviewedRequestsPageState();
}

class _ReviewedRequestsPageState extends State<ReviewedRequestsPage> {
  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            appBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 9),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(top: 13, bottom: index == 9 ? 13 : 0),
                      child: RequestCard(
                          requestStatus: index % 2 == 0
                              ? RequestStatus.approved
                              : RequestStatus.rejected),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Container(
        color: AppColors.secondaryBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 14),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 14),
                child: GestureDetector(
                  onTap: onBack,
                  child: Image.asset(
                    "assets/icons/back-btn-2.png",
                    width: 10,
                    height: 18,
                  ),
                ),
              ),
              Text(
                "Reviewed Requests",
                style: getTextStyle(
                    textColor: AppColors.secondaryYellow,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 20),
              )
            ],
          ),
        ),
      );
}
