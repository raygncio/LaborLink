import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/models/offer.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';

DatabaseService service = DatabaseService();

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
  double _totalOffer = 0.0;
  String _offerDesc = '';
  File? _offerAttachment;

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
        height: 339,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              label: "Request ID: " +
                                  widget.requestInfo["ActiveRequestId"],
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
                                      "assets/icons/${widget.requestInfo['specialization'].toString().toLowerCase()}.png",
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
                                SizedBox(
                                  width: 160,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: TextWithIcon(
                                      icon: const Icon(Icons.place,
                                          size: 13,
                                          color: AppColors.accentOrange),
                                      text: widget.requestInfo['address'],
                                      fontSize: 12,
                                      contentPadding: 8,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.75),
                                  child: TextWithIcon(
                                    icon: const Icon(Icons.local_offer_rounded,
                                        size: 13,
                                        color: AppColors.accentOrange),
                                    text: widget.requestInfo["suggestedPrice"]
                                            .toString() ??
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
                                  icon: const Icon(Icons.calendar_month_rounded,
                                      size: 13, color: AppColors.accentOrange),
                                  text: widget.requestInfo["date"] ?? '',
                                  fontSize: 9,
                                  contentPadding: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.75),
                                  child: TextWithIcon(
                                    icon: const Icon(Icons.watch_later,
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
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.5),
                          child: Image.network(
                            widget.requestInfo["attachment"],
                            height: 151,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 4.5),
                      //     child: Image.network(
                      //       imgPlaceholder,
                      //       height: 101,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
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

  void onAccept() async {
    // Accept the request, update the request
    // direct to home page
    try {
      await service.updateRequestProgress(
          widget.requestInfo["ActiveRequestId"], widget.userId);
    } catch (e) {
      // Handle errors during user creation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error creating user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HandymanMainPage(userId: widget.userId)));
  }

  _getTotalFee(double fee) {
    setState(() {
      _totalOffer = fee;
      print('>>>>>>>makeoffer: $_totalOffer');
    });
  }

  _getOfferData(String desc, File file) {
    setState(() {
      _offerAttachment = file;
      _offerDesc = desc;
    });
  }

  _submitOffer() async {
    try {
      // Create a user in Firebase Authentication
      String imageUrl =
          await service.uploadOfferAttachment(widget.userId, _offerAttachment!);

      print('>>>>>>>>>>>>submitoffer>>$_totalOffer,$_offerDesc,$imageUrl');

      Offer offers = Offer(
        bidPrice: _totalOffer,
        status: 'pending',
        description: _offerDesc,
        attachment: imageUrl,
        userId: widget.userId,
        requestId: widget.requestInfo['ActiveRequestId'],
      );

      await service.addOffers(offers);
    } catch (e) {
      // Handle errors during user creation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error creating user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onMakeOffer() {
    makeOfferDialog(context, _getTotalFee, _getOfferData).then(
      (value) {
        if (value == null) return;

        if (value == "submit") {
          _submitOffer();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OfferSubmittedPage()));
        }
      },
    );
  }

  void onDecline() async {
    DatabaseService service = DatabaseService();
    try {
      await service.declineDirectRequest(widget.requestInfo["ActiveRequestId"]);
      Future.delayed(Duration(milliseconds: 400), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Direct Request declined succesfully."),
            backgroundColor: Color.fromARGB(255, 15, 83, 186),
          ),
        );
      });
    } catch (e) {
      print('Error updating document: $e');
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          HandymanMainPage(userId: widget.requestInfo["handymanId"]),
    ));
  }
}
