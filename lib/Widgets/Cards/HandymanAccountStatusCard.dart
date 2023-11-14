import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/styles.dart';

enum HandymanAccountStatus {
  active,
  pending,
  blocked,
}

class HandymanAccountStatusCard extends StatefulWidget {
  final handymanInfo;
  final accountStatus;
  const HandymanAccountStatusCard(
      {Key? key, required this.handymanInfo, required this.accountStatus})
      : super(key: key);

  @override
  State<HandymanAccountStatusCard> createState() =>
      _HandymanAccountStatusCardState();
}

class _HandymanAccountStatusCardState extends State<HandymanAccountStatusCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 14, right: 14, top: 6.61, bottom: 8.71),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey)),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      height: 61,
                      width: 61,
                      child: ClipOval(
                        child: Image.network(widget.handymanInfo["img_url"]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.handymanInfo["name"],
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: AppBadge(
                                label: "ID: 12345",
                                type: BadgeType.normal,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 1),
                              ),
                            ),
                            Visibility(
                              visible: widget.accountStatus !=
                                  HandymanAccountStatus.pending,
                              child: AppBadge(
                                label: widget.accountStatus ==
                                        HandymanAccountStatus.active
                                    ? "Active"
                                    : "Blocked",
                                type: widget.accountStatus ==
                                        HandymanAccountStatus.active
                                    ? BadgeType.normal
                                    : BadgeType.blocked,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 1),
                              ),
                            )
                          ],
                        ),
                        widget.accountStatus != HandymanAccountStatus.pending
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: RateWidget(
                                    rate: widget.handymanInfo["rating"],
                                    iconSize: 11),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(
                                          color: AppColors.dirtyWhite,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Image.asset(
                                          "assets/icons/${widget.handymanInfo['service'].toLowerCase()}.png",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.handymanInfo["service"],
                                      style: getTextStyle(
                                          textColor: AppColors.secondaryBlue,
                                          fontFamily: AppFonts.montserrat,
                                          fontWeight: AppFontWeights.bold,
                                          fontSize: 10),
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.89),
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
                                  icon: Icon(Icons.phone,
                                      size: 13, color: AppColors.accentOrange),
                                  text: "09223595695",
                                  fontSize: 9,
                                  contentPadding: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: columnWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWithIcon(
                                icon: Icon(Icons.email,
                                    size: 13, color: AppColors.accentOrange),
                                text: "HanniPham@gmail.com",
                                fontSize: 9,
                                contentPadding: 8,
                              ),
                              widget.accountStatus !=
                                      HandymanAccountStatus.pending
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 6.75),
                                      child: TextWithIcon(
                                        icon: Icon(Icons.handyman,
                                            size: 13,
                                            color: AppColors.accentOrange),
                                        text: "Plumbing",
                                        fontSize: 9,
                                        contentPadding: 8,
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.only(top: 6.75),
                                      child: TextWithIcon(
                                        icon: Icon(Icons.business_center,
                                            size: 13,
                                            color: AppColors.accentOrange),
                                        text: "Previous Employer",
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
              Visibility(
                visible: widget.accountStatus == HandymanAccountStatus.pending,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      AppFilledButton(
                          padding: const EdgeInsets.only(right: 10),
                          height: 19,
                          text: "Submitted ID",
                          fontSize: 9,
                          textColor: AppColors.secondaryBlue,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.blueBadge,
                          command: () {},
                          borderRadius: 8),
                      AppFilledButton(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: 19,
                          text: "NBI Clearance",
                          fontSize: 9,
                          textColor: AppColors.secondaryBlue,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.blueBadge,
                          command: () {},
                          borderRadius: 8),
                      AppFilledButton(
                          padding: const EdgeInsets.only(left: 10),
                          height: 19,
                          text: "Certification",
                          fontSize: 9,
                          textColor: AppColors.secondaryBlue,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.blueBadge,
                          command: () {},
                          borderRadius: 8)
                    ],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: widget.accountStatus != HandymanAccountStatus.pending
                ? SizedBox(
                    width: 71,
                    child: Row(
                      children: [
                        AppFilledButton(
                            height: 20,
                            text: widget.accountStatus ==
                                    HandymanAccountStatus.active
                                ? "Block"
                                : "Activate",
                            fontSize: 9,
                            textColor: widget.accountStatus ==
                                    HandymanAccountStatus.active
                                ? AppColors.black
                                : null,
                            fontFamily: AppFonts.montserrat,
                            color: widget.accountStatus ==
                                    HandymanAccountStatus.active
                                ? AppColors.dirtyWhite
                                : AppColors.secondaryBlue,
                            command: widget.accountStatus ==
                                    HandymanAccountStatus.active
                                ? () {
                                    yesCancelDialog(context,
                                        "Are you sure you want to block this account?");
                                  }
                                : () {
                                    yesCancelDialog(context,
                                        "Are you sure you want to activate this account?");
                                  },
                            borderRadius: 8)
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: 71,
                        child: Row(
                          children: [
                            AppFilledButton(
                                height: 20,
                                text: "Approve",
                                fontSize: 9,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.accentOrange,
                                command: () {
                                  yesCancelDialog(context,
                                      "Are you sure you want to approve this account?");
                                },
                                borderRadius: 8),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.86),
                        child: SizedBox(
                          width: 71,
                          child: Row(
                            children: [
                              AppFilledButton(
                                  height: 20,
                                  text: "Decline",
                                  fontSize: 9,
                                  fontFamily: AppFonts.montserrat,
                                  textColor: AppColors.black,
                                  color: AppColors.dirtyWhite,
                                  command: () {
                                    yesCancelDialog(context,
                                        "Are you sure you want to decline this account?");
                                  },
                                  borderRadius: 8)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
