import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Home/DirectRequestFormPage.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';

class HandymanDirectRequestCard extends StatefulWidget {
  final Function(String) submitRequest;
  final Map<String, dynamic> handymanInfo;
  const HandymanDirectRequestCard(
      {Key? key, required this.handymanInfo, required this.submitRequest})
      : super(key: key);

  @override
  State<HandymanDirectRequestCard> createState() =>
      _HandymanDirectRequestCardState();
}

class _HandymanDirectRequestCardState extends State<HandymanDirectRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, right: 10, top: 10, bottom: 10),
          child: Row(
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
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 85,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        AppFilledButton(
                            fontSize: 9,
                            height: 20,
                            fontFamily: AppFonts.montserrat,
                            text: "Direct Request",
                            color: AppColors.accentOrange,
                            command: onDirectRequest,
                            borderRadius: 8),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 71,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        AppFilledButton(
                            padding: const EdgeInsets.only(top: 4),
                            fontSize: 9,
                            height: 20,
                            fontFamily: AppFonts.montserrat,
                            text: "View Profile",
                            color: AppColors.secondaryBlue,
                            command: onViewProfile,
                            borderRadius: 8),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDirectRequest() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) =>
          DirectRequestFormPage(handymanInfo: widget.handymanInfo),
    ))
        .then((value) {
      if (value == null) return;

      if (value == "submit") {
        widget.submitRequest("direct");
      }
    });
  }

  void onViewProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewHandymanProfile(handymanInfo: widget.handymanInfo),
    ));
  }
}
