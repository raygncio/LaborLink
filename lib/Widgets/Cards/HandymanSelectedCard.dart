import 'package:flutter/material.dart';
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
                    child: Image.network(widget.handymanInfo["img_url"]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
            const Align(
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
}
