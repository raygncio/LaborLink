import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/handyman_approval.dart';
import 'package:laborlink/models/database_service.dart';

import '../Dialogs.dart';

class OpenRequestCard extends StatefulWidget {
  final Map<String, dynamic> clientRequestInfo;
  final String userId;
  const OpenRequestCard(
      {Key? key, required this.clientRequestInfo, required this.userId})
      : super(key: key);

  @override
  State<OpenRequestCard> createState() => _OpenRequestCardState();
}

class _OpenRequestCardState extends State<OpenRequestCard> {
  @override
  Widget build(BuildContext context) {
    String firstName = widget.clientRequestInfo['firstName'] ?? '';
    String middleName = widget.clientRequestInfo['middleName'] ?? '';
    String lastName = widget.clientRequestInfo['lastName'] ?? '';
    String suffix = widget.clientRequestInfo['suffix'] ?? '';

    // Concatenate non-null values
    String fullname = '$firstName $middleName $lastName $suffix';

    final String requestId = widget.clientRequestInfo['requestId'] ?? '';
    final String category = widget.clientRequestInfo['category'] ?? '';
    final String title = widget.clientRequestInfo['title'] ?? '';
    final String address = widget.clientRequestInfo['address'] ?? '';
    final double? suggestedFee =
        widget.clientRequestInfo['suggestedPrice'] as double?;
    final String date = widget.clientRequestInfo['date'] ?? '';
    final String time = widget.clientRequestInfo['time'] ?? '';
    final String description = widget.clientRequestInfo['description'] ?? '';
    final String attachment = widget.clientRequestInfo['attachment'] ?? '';

    return Container(
      height: 279,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
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
                            fullname,
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.27),
                            child: AppBadge(
                              label: requestId,
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
                                  title,
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
                  top: 8,
                  right: 0,
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
                                padding: const EdgeInsets.only(top: 4.73),
                                height: 19.27,
                                text: "Make Offer",
                                fontSize: 9,
                                fontFamily: AppFonts.montserrat,
                                color: AppColors.secondaryBlue,
                                command: onMakeOffer,
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
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 11.65),
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
                            text: address,
                            fontSize: 9,
                            contentPadding: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.75),
                            child: TextWithIcon(
                              icon: Icon(Icons.local_offer_rounded,
                                  size: 13, color: AppColors.accentOrange),
                              text: suggestedFee.toString(),
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
                            text: date,
                            fontSize: 9,
                            contentPadding: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.75),
                            child: TextWithIcon(
                              icon: Icon(Icons.watch_later,
                                  size: 13, color: AppColors.accentOrange),
                              text: time,
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
              description,
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
    );
  }

  void onAccept() async {
    // need to update the request and put the document id of handyman to the database
    DatabaseService service = DatabaseService();
    try {
      HandymanApproval handymanApproval = HandymanApproval(
        status: 'pending',
        handymanId: widget.userId,
        requestId: widget.clientRequestInfo["userId"],
      );

      await service.addHandymanApproval(handymanApproval);
      // need to put a pop up kapag nag update
    } catch (e) {
      print('Error: $e');
    }
  }

  void onMakeOffer() {
    makeOfferDialog(context).then((value) {
      if (value == null) return;

      if (value == "submit") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const OfferSubmittedPage()));
      }
    });
  }
}
