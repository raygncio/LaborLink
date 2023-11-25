import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';

class HandymanInfoCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const HandymanInfoCard({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<HandymanInfoCard> createState() => HandymanInfoCardState();
}

class HandymanInfoCardState extends State<HandymanInfoCard> {
  late String fullname;

  @override
  void initState() {
    super.initState();
    initializeFullname();
  }

  void initializeFullname() {
    String firstName = widget.handymanInfo['firstName'] ?? '';
    String middleName = widget.handymanInfo['middleName'] ?? '';
    String lastName = widget.handymanInfo['lastName'] ?? '';
    String suffix = widget.handymanInfo['suffix'] ?? '';

    fullname = '$firstName $middleName $lastName $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: AppColors.blackShadow,
            ),
          ]),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            // SizedBox(
            //   height: 61,
            //   width: 61,
            //   child: ClipOval(
            //     child: Image.network(widget.handymanInfo["img_url"]),
            //   ),
            // ),
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
                              label: widget.handymanInfo["specialization"],
                              type: BadgeType.normal),
                        ),
                        AppBadge(
                            label: widget.handymanInfo["city"],
                            type: BadgeType.normal)
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 4),
                  //   child: RateWidget(
                  //       rate: widget.handymanInfo["rating"], iconSize: 12),
                  // ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.dirtyWhite,
                borderRadius: BorderRadius.circular(50),
              ),
              //  child: Image.asset(
              //      "assets/icons/$widget.handymanInfo['category'] as String?)?.toLowerCase() ?? '')}.png",
              //      width: 50,
              //      height: 48),
            ),
          ],
        ),
      ),
    );
  }
}
