import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/styles.dart';

enum PendingRequestType {
  openRequest,
  directRequest,
  forApproval,
}

class PendingRequestInfoCard extends StatefulWidget {
  final PendingRequestType type;
  final Map<String, dynamic> requestDetail;
  const PendingRequestInfoCard(
      {Key? key, required this.type, required this.requestDetail})
      : super(key: key);

  @override
  State<PendingRequestInfoCard> createState() => _PendingRequestInfoCardState();
}

class _PendingRequestInfoCardState extends State<PendingRequestInfoCard> {
  late BadgeType badgeType;
  late String badgeLabel;
  late String title;
  late String address;
  late String date;
  late String time;
  late double suggestedFee;
  late String userId;

  @override
  void initState() {
    title = widget.requestDetail["title"];
    address = widget.requestDetail["address"];
    date = widget.requestDetail["date"];
    time = widget.requestDetail["time"];
    suggestedFee = widget.requestDetail["suggestedFee"];
    userId = widget.requestDetail["userId"];

    switch (widget.type) {
      case PendingRequestType.openRequest:
      case PendingRequestType.directRequest:
        badgeLabel =
            "${widget.type == PendingRequestType.openRequest ? "Open" : "Direct"} Request";
        badgeType = BadgeType.normal;
        break;
      case PendingRequestType.forApproval:
        badgeLabel = "For Approval";
        badgeType = BadgeType.blocked;
        break;
    }
    super.initState();
  }

  void onCancelRequest() async {
    DatabaseService service = DatabaseService();
    try {
      await service.cancelRequest(userId);
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 192,
      width: deviceWidth,
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 12,
                color: AppColors.blackShadow)
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 26, right: 24, bottom: 17),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          title,
                          style: getTextStyle(
                              textColor: AppColors.tertiaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 17),
                        ),
                      ),
                      AppBadge(
                          label: badgeLabel,
                          type: badgeType,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2)),
                    ],
                  ),
                ),
                Text(
                  "Request ID",
                  style: getTextStyle(
                      textColor: AppColors.tertiaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 13),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextWithIcon(
                        icon: Icon(Icons.place,
                            size: 17, color: AppColors.accentOrange),
                        text: address,
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TextWithIcon(
                        icon: Icon(Icons.calendar_month_rounded,
                            size: 17, color: AppColors.accentOrange),
                        text: date,
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TextWithIcon(
                        icon: Icon(Icons.watch_later,
                            size: 17, color: AppColors.accentOrange),
                        text: time,
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TextWithIcon(
                        icon: Icon(Icons.local_offer_rounded,
                            size: 17, color: AppColors.accentOrange),
                        text: suggestedFee.toString(),
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              top: 14,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: AppColors.dirtyWhite,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset("assets/icons/plumbing.png",
                        width: 50, height: 48),
                  ),
                  SizedBox(
                    width: 85,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        AppOutlinedButton(
                            height: 20,
                            padding: const EdgeInsets.only(top: 16),
                            text: "Cancel Request",
                            textStyle: getTextStyle(
                                textColor: AppColors.accentOrange,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 9),
                            color: AppColors.accentOrange,
                            command: onCancelRequest,
                            borderRadius: 8,
                            borderWidth: 1),
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
}
