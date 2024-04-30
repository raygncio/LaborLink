import 'package:flutter/material.dart';
// import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/users.dart';

import '../Dialogs.dart';

enum IssueStatus { approved, returned, resolved, pending }

class IssueCard extends StatefulWidget {
  final String issueStatus;
  final String reporterUserType;
  const IssueCard(
      {Key? key, required this.issueStatus, required this.reporterUserType})
      : super(key: key);

  @override
  State<IssueCard> createState() => _IssueCardState();
}

class _IssueCardState extends State<IssueCard> {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 2.85),
                        child: Column(
                          children: [
                            Text(
                              "Hanni Pham",
                              style: getTextStyle(
                                  textColor: AppColors.secondaryBlue,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: AppFontWeights.bold,
                                  fontSize: 15),
                            ),
                            widget.reporterUserType == AppUserType.client.toString()
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 1.27),
                                    child: AppBadge(
                                      label: "Request ID: 12345",
                                      type: BadgeType.normal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 1),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 2.51),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3),
                                          child: Container(
                                            height: 14,
                                            width: 13.18,
                                            decoration: BoxDecoration(
                                              color: AppColors.dirtyWhite,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Image.asset(
                                              "assets/icons/plumbing.png",
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Clogged Toilet",
                                          style: getTextStyle(
                                              textColor:
                                                  AppColors.secondaryBlue,
                                              fontFamily: AppFonts.montserrat,
                                              fontWeight: AppFontWeights.bold,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 11.35,
                  right: 0,
                  child: widget.issueStatus == IssueStatus.pending.toString()
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
                                            "Are you sure you want to approve this issue?");
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
                                      text: "Return",
                                      fontSize: 9,
                                      textColor: AppColors.black,
                                      fontFamily: AppFonts.montserrat,
                                      color: AppColors.dirtyWhite,
                                      command: () {
                                        yesCancelDialog(context,
                                            "Are you sure you want to return this issue?");
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
                                  text:
                                      widget.issueStatus == IssueStatus.approved.toString()
                                          ? "Resolve"
                                          : widget.issueStatus ==
                                                  IssueStatus.resolved.toString()
                                              ? "Resolved"
                                              : "Returned",
                                  fontSize: 9,
                                  fontFamily: AppFonts.montserrat,
                                  color:
                                      widget.issueStatus == IssueStatus.approved.toString()
                                          ? AppColors.accentOrange
                                          : widget.issueStatus ==
                                                  IssueStatus.resolved.toString()
                                              ? AppColors.green
                                              : AppColors.dirtyWhite,
                                  textColor:
                                      widget.issueStatus != IssueStatus.returned.toString()
                                          ? null
                                          : AppColors.black,
                                  command:
                                      widget.issueStatus == IssueStatus.approved.toString()
                                          ? () {
                                              yesCancelDialog(context,
                                                  "Are you sure this report has been resolved?");
                                            }
                                          : null,
                                  borderRadius: 8),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 7.65),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double columnWidth = constraints.maxWidth / 2;

                return Row(
                  children: [
                    SizedBox(
                      width: columnWidth,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipOval(
                              child: Image.network(
                                imgUrl,
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.reporterUserType == AppUserType.client.toString()
                                    ? "Handyman Name"
                                    : "Client Name",
                                style: getTextStyle(
                                    textColor: AppColors.secondaryBlue,
                                    fontFamily: AppFonts.montserrat,
                                    fontWeight: AppFontWeights.bold,
                                    fontSize: 10),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: RateWidget(rate: 5, iconSize: 6),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: columnWidth,
                      child: widget.reporterUserType == AppUserType.client.toString()
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Container(
                                    height: 14,
                                    width: 13.18,
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
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 1.27),
                              child: Row(
                                children: [
                                  AppBadge(
                                    label: "Request ID: 12345",
                                    type: BadgeType.normal,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 1),
                                  ),
                                ],
                              ),
                            ),
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 8),
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
