import 'package:flutter/material.dart';
// import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

import '../Dialogs.dart';

enum RequestStatus { approved, rejected, pending }

class RequestCard extends StatefulWidget {
  final requestStatus;
  const RequestCard({Key? key, required this.requestStatus})
      : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey)),
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
                  top: 11.35,
                  right: 0,
                  child: widget.requestStatus == RequestStatus.pending
                      ? Column(
                          children: [
                            SizedBox(
                              width: 71,
                              child: Row(
                                children: [
                                  AppFilledButton(
                                      height: 19.27,
                                      text: "Approve",
                                      fontSize: 9,
                                      fontFamily: AppFonts.montserrat,
                                      color: AppColors.accentOrange,
                                      command: () {
                                        yesCancelDialog(context,
                                            "Are you sure you want to approve this request?");
                                      },
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
                                      text: "Decline",
                                      fontSize: 9,
                                      textColor: AppColors.black,
                                      fontFamily: AppFonts.montserrat,
                                      color: AppColors.dirtyWhite,
                                      command: () {
                                        yesCancelDialog(context,
                                            "Are you sure you want to decline this request?");
                                      },
                                      borderRadius: 8),
                                ],
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          width: 71,
                          child: Row(
                            children: [
                              AppFilledButton(
                                  height: 19.27,
                                  text: widget.requestStatus ==
                                          RequestStatus.approved
                                      ? "Approved"
                                      : "Rejected",
                                  fontSize: 9,
                                  fontFamily: AppFonts.montserrat,
                                  color: widget.requestStatus ==
                                          RequestStatus.approved
                                      ? AppColors.secondaryBlue
                                      : AppColors.dirtyWhite,
                                  textColor: widget.requestStatus ==
                                          RequestStatus.approved
                                      ? null
                                      : AppColors.black,
                                  command: null,
                                  borderRadius: 8),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 11.65),
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
            padding:
                const EdgeInsets.only(left: 12, right: 13, top: 10, bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.network(
                      imgPlaceholder,
                      height: 101,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
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
}
