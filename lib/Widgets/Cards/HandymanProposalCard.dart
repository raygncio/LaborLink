import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ViewHandymanProposal.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';

class HandymanProposalCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const HandymanProposalCard({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<HandymanProposalCard> createState() => HandymanProposalCardState();
}

class HandymanProposalCardState extends State<HandymanProposalCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 61,
                  width: 61,
                  child: ClipOval(
                    child: Image.network(widget.handymanInfo["img_url"]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.handymanInfo['name'],
                          style: getTextStyle(
                              textColor: AppColors.primaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: AppBadge(
                                  label: widget.handymanInfo["service"],
                                  type: BadgeType.normal),
                            ),
                            AppBadge(
                                label: widget.handymanInfo["area"],
                                type: BadgeType.normal)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RateWidget(
                            rate: widget.handymanInfo["rating"], iconSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 18,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const AppBadge(
                    label: "Offered ₱650 ",
                    type: BadgeType.offer,
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  ),
                  SizedBox(
                    width: 85,
                    child: Row(
                      children: [
                        AppFilledButton(
                            padding: const EdgeInsets.only(top: 6),
                            height: 20,
                            text: "View Proposal",
                            fontSize: 9,
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.secondaryBlue,
                            command: onViewProposal,
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
    );
  }

  void onViewProposal() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewHandymanProposal(handymanInfo: widget.handymanInfo),
    ));
  }
}
