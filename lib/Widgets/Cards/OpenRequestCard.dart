import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

import '../Dialogs.dart';

class OpenRequestCard extends StatefulWidget {
  const OpenRequestCard({Key? key}) : super(key: key);

  @override
  State<OpenRequestCard> createState() => _OpenRequestCardState();
}

class _OpenRequestCardState extends State<OpenRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 279,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.64),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipOval(
                          child: Image.network(
                            imgUrl,
                            width: 63,
                            height: 60.72,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Hanni Pham",
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 15),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 1.27),
                            child: AppBadge(
                              label: "Request ID: 12345",
                              type: BadgeType.normal,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.74),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Container(
                                    height: 12.35,
                                    width: 12.35,
                                    decoration: BoxDecoration(
                                      color: AppColors.dirtyWhite,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.asset(
                                      "assets/icons/plumbing.png",
                                    ),
                                  ),
                                ),
                                Text(
                                  "Clogged Toilet",
                                  style: getTextStyle(
                                      textColor: AppColors.secondaryBlue,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 71,
                        child: Row(
                          children: [
                            AppFilledButton(
                                height: 19.27,
                                text: "Accept",
                                fontSize: 9,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.accentOrange,
                                command: onAccept,
                                borderRadius: 8),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 71,
                        child: Row(
                          children: [
                            AppFilledButton(
                                padding: const EdgeInsets.only(top: 4.73),
                                height: 19.27,
                                text: "Make Offer",
                                fontSize: 9,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.secondaryBlue,
                                command: onMakeOffer,
                                borderRadius: 8),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 11.65),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double columnWidth = constraints.maxWidth / 2;

                return Row(
                  children: [
                    SizedBox(
                      width: columnWidth,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWithIcon(
                            icon: Icon(Icons.place,
                                size: 13, color: AppColors.accentOrange),
                            text: "556 Juan Luna Ave.",
                            fontSize: 9,
                            contentPadding: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.75),
                            child: TextWithIcon(
                              icon: Icon(Icons.local_offer_rounded,
                                  size: 13, color: AppColors.accentOrange),
                              text: "₱550",
                              fontSize: 9,
                              contentPadding: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: columnWidth,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWithIcon(
                            icon: Icon(Icons.calendar_month_rounded,
                                size: 13, color: AppColors.accentOrange),
                            text: "07 Aug 2023",
                            fontSize: 9,
                            contentPadding: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.75),
                            child: TextWithIcon(
                              icon: Icon(Icons.watch_later,
                                  size: 13, color: AppColors.accentOrange),
                              text: "12:00 - 1:00 PM",
                              fontSize: 9,
                              contentPadding: 8,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 8.27),
            child: Text(
              "I'm experiencing a clogged sink issue in my kitchen that requires attention. The clog seems to be located near the drain area and has been causing slow drainage over the past few days.",
              overflow: TextOverflow.visible,
              style: getTextStyle(
                  textColor: AppColors.black,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.5),
                    child: Image.network(
                      imgPlaceholder,
                      height: 101,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.network(
                      imgPlaceholder,
                      height: 101,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onAccept() {}

  void onMakeOffer() {
    makeOfferDialog(context).then((value) {
      if (value == null) return;

      if (value == "submit") {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OfferSubmittedPage()));
      }
    });
  }
}
