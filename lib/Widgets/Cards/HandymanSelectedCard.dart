import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ViewHandymanProposal.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';

class HandymanSelectedCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const HandymanSelectedCard({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<HandymanSelectedCard> createState() => HandymanSelectedCardState();
}

class HandymanSelectedCardState extends State<HandymanSelectedCard> {
  @override
  Widget build(BuildContext context) {
    String firstName = widget.handymanInfo['firstName'] ?? '';
    String middleName = widget.handymanInfo['middleName'] ?? '';
    String lastName = widget.handymanInfo['lastName'] ?? '';
    String suffix = widget.handymanInfo['suffix'] ?? '';

    String fullname = '$firstName $middleName $lastName $suffix';
    print("GET THE DIRECT INFO: $fullname");
    bool hasBidPrice = widget.handymanInfo.containsKey('bidPrice');
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 10, top: 10, bottom: 10),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 61,
                  width: 61,
                  child: ClipOval(
                    child: Image.asset("assets/icons/person-circle-blue.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullname,
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
                                  label:
                                      widget.handymanInfo["specialization"] ??
                                          ' ',
                                  type: BadgeType.normal),
                            ),
                            AppBadge(
                                label: widget.handymanInfo["city"] ?? ' ',
                                type: BadgeType.normal)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RateWidget(
                            rate: (widget.handymanInfo["rating"] ?? 3).toInt(),
                            iconSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasBidPrice)
              Positioned(
                top: 18,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppBadge(
                      label: "Offered ₱ ${widget.handymanInfo["bidPrice"]}",
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
                            borderRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: AppBadge(
                    label: "Waiting",
                    type: BadgeType.blocked,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  ),
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
