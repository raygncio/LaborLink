import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({Key? key}) : super(key: key);

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  final _reviewController = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: Stack(
            children: [
              SizedBox(
                width: deviceWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 98 + 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Rob Shandell Bautista",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 25),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Container(
                                height: 21.18,
                                width: 21.18,
                                decoration: BoxDecoration(
                                  color: AppColors.dirtyWhite,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset("assets/icons/plumbing.png",
                                    width: 23.53, height: 22.59),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Text(
                                "Clogged Toilet",
                                style: getTextStyle(
                                    textColor: AppColors.secondaryBlue,
                                    fontFamily: AppFonts.montserrat,
                                    fontWeight: AppFontWeights.bold,
                                    fontSize: 10),
                              ),
                            ),
                            const AppBadge(
                              label: "Handyman",
                              type: BadgeType.normal,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 43),
                          child: Text(
                            "Rate your overall experience!",
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "We would love to hear your feedback",
                            style: getTextStyle(
                                textColor: AppColors.black,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 15),
                          ),
                        ),
                        ratingWidget(),
                        Padding(
                          padding: const EdgeInsets.only(top: 27),
                          child: Text(
                            "Tell us about the service!",
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 38, right: 37, top: 6),
                          child: TextAreaFormField(
                              controller: _reviewController,
                              height: 199,
                              maxLength: 100,
                              inputTextStyle: getTextStyle(
                                  textColor: AppColors.black,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: AppFontWeights.regular,
                                  fontSize: 12),
                              defaultBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: AppColors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: AppColors.grey),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: 127,
                            child: Row(
                              children: [
                                AppFilledButton(
                                    height: 32,
                                    text: "Submit",
                                    fontSize: 15,
                                    fontFamily: AppFonts.montserrat,
                                    color: AppColors.accentOrange,
                                    command: () {},
                                    borderRadius: 5),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 98,
                width: deviceWidth,
                decoration: const BoxDecoration(
                    color: AppColors.secondaryBlue,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: AppColors.blackShadow,
                      )
                    ]),
                child: Stack(
                  children: [
                    Positioned(
                      top: 17,
                      left: 14,
                      child: GestureDetector(
                        onTap: onBack,
                        child: Image.asset(
                          "assets/icons/back-btn-2.png",
                          width: 12,
                          height: 23,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const FractionalOffset(0.5, 5),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: AppColors.white, shape: BoxShape.circle),
                        child: ClipOval(
                            child:
                                Image.network(imgUrl, width: 75, height: 75)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ratingWidget() => Padding(
        padding: const EdgeInsets.only(top: 23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 1;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 1
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 2;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 2
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 3;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 3
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 4;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 4
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 5;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 5
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
          ],
        ),
      );

  void onBack() => Navigator.of(context).pop();
}
