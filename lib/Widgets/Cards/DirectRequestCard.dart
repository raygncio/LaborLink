import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';

class DirectRequestCard extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> requestInfo;
  const DirectRequestCard(
      {Key? key, required this.userId, required this.requestInfo})
      : super(key: key);

  @override
  State<DirectRequestCard> createState() => _DirectRequestCardState();
}

class _DirectRequestCardState extends State<DirectRequestCard> {
  late String fullname;

  @override
  void initState() {
    super.initState();
    initializeFullname();
  }

  void initializeFullname() {
    String firstName = widget.requestInfo['firstName'] ?? '';
    String middleName = widget.requestInfo['middleName'] ?? '';
    String lastName = widget.requestInfo['lastName'] ?? '';
    String suffix = widget.requestInfo['suffix'] ?? '';

    fullname = '$firstName $middleName $lastName $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 9, top: 12),
      child: Container(
        height: 279,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey, width: 0.7)),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 6.64),
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
                            fullname,
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
                                  widget.requestInfo["title"],
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, top: 11.65),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double columnWidth = constraints.maxWidth / 2;

                      return Row(
                        children: [
                          SizedBox(
                            width: columnWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWithIcon(
                                  icon: Icon(Icons.place,
                                      size: 13, color: AppColors.accentOrange),
                                  text: widget.requestInfo["address"] ?? '',
                                  fontSize: 9,
                                  contentPadding: 8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.75),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.local_offer_rounded,
                                        size: 13,
                                        color: AppColors.accentOrange),
                                    text: widget.requestInfo["suggestedFee"] ??
                                        '',
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
                                TextWithIcon(
                                  icon: Icon(Icons.calendar_month_rounded,
                                      size: 13, color: AppColors.accentOrange),
                                  text: widget.requestInfo["date"] ?? '',
                                  fontSize: 9,
                                  contentPadding: 8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.75),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.watch_later,
                                        size: 13,
                                        color: AppColors.accentOrange),
                                    text: widget.requestInfo["time"] ?? '',
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
                  padding:
                      const EdgeInsets.only(left: 13, right: 13, top: 8.27),
                  child: Text(
                    widget.requestInfo["description"],
                    overflow: TextOverflow.visible,
                    style: getTextStyle(
                        textColor: AppColors.black,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.regular,
                        fontSize: 9),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.only(right: 4.5),
                //           child: Image.network(
                //             imgPlaceholder,
                //             height: 101,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.only(left: 4.5),
                //           child: Image.network(
                //             imgPlaceholder,
                //             height: 101,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
            Positioned(
              top: 10.38,
              right: 10,
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
                            padding: const EdgeInsets.only(top: 4.82),
                            height: 19.27,
                            text: "Make Offer",
                            fontSize: 9,
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.secondaryBlue,
                            command: onMakeOffer,
                            borderRadius: 8),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 71,
                    child: Row(
                      children: [
                        AppFilledButton(
                            height: 19.27,
                            padding: const EdgeInsets.only(top: 4.29),
                            text: "Decline",
                            textColor: AppColors.black,
                            fontSize: 9,
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.blackBadge,
                            command: onDecline,
                            borderRadius: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onAccept() {}

  void onMakeOffer() {
    makeOfferDialog(context).then((value) {
      if (value == null) return;

      if (value == "submit") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const OfferSubmittedPage()));
      }
    });
  }

  void onDecline() async {
    DatabaseService service = DatabaseService();
    try {
      await service.declineDirectRequest(widget.requestInfo["userId"]);
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }
}
