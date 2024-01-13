import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Pages/Handyman/Home/OfferSumbittedPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/models/offer.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/handyman_approval.dart';
import 'package:laborlink/models/database_service.dart';

import '../Dialogs.dart';

DatabaseService service = DatabaseService();

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
  double _totalOffer = 0.0;
  String _offerDesc = '';
  File? _offerAttachment;

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          height: 55,
                          width: 55,
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            child: ClipOval(
                                child: Image.asset(
                                    'assets/icons/person-circle-blue.png')),
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
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                      "assets/icons/${widget.clientRequestInfo['category'].toString().toLowerCase()}.png",
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: getTextStyle(
                                          textColor: AppColors.secondaryBlue,
                                          fontFamily: AppFonts.montserrat,
                                          fontWeight: AppFontWeights.medium,
                                          fontSize: 12),
                                    ),
                                    AppBadge(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 8),
                                        label:
                                            '${widget.clientRequestInfo['category']}',
                                        type: BadgeType.normal),
                                  ],
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: TextWithIcon(
                              icon: const Icon(Icons.place,
                                  size: 13, color: AppColors.accentOrange),
                              text: address,
                              fontSize: 12,
                              contentPadding: 8,
                            ),
                          ),
                          // TextWithIcon(
                          //   icon: const Icon(Icons.place,
                          //       size: 13, color: AppColors.accentOrange),
                          //   text: address,
                          //   fontSize: 12,
                          //   contentPadding: 8,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.75),
                            child: TextWithIcon(
                              icon: const Icon(Icons.local_offer_rounded,
                                  size: 13, color: AppColors.accentOrange),
                              text: suggestedFee.toString(),
                              fontSize: 12,
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
                            text: date,
                            fontSize: 12,
                            contentPadding: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.75),
                            child: TextWithIcon(
                              icon: const Icon(Icons.watch_later,
                                  size: 13, color: AppColors.accentOrange),
                              text: time,
                              fontSize: 12,
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
            padding: const EdgeInsets.only(left: 13, right: 13, top: 12),
            child: Text(
              description,
              overflow: TextOverflow.visible,
              style: getTextStyle(
                  textColor: AppColors.black,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image.network(attachment),
          ),
        ],
      ),
    );
  }

  void onAccept() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you really want to accept this request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform action on 'No' button press (if needed)
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform action on 'Yes' button press
                performAcceptAction();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void performAcceptAction() async {
    //  logic to update the request and put the document ID of the handyman in the database
    DatabaseService service = DatabaseService();
    try {
      HandymanApproval handymanApproval = HandymanApproval(
        status: 'pending',
        handymanId: widget.userId,
        requestId: widget.clientRequestInfo["requestId"],
      );

      await service.addHandymanApproval(handymanApproval);
      // Show a success message or perform further actions upon accepting the request

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request accepted succesfully."),
          backgroundColor: Color.fromARGB(255, 54, 114, 244),
        ),
      );

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HandymanMainPage(userId: widget.userId),
      ));
    } catch (e) {
      print('Error: $e');
      // Handle error scenario if required
    }
    setState(() {});
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

      print(
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%submitoffer>>$_totalOffer,$_offerDesc,$imageUrl,${widget.userId},${widget.clientRequestInfo['requestId']}');

      Offer offers = Offer(
        bidPrice: _totalOffer,
        status: 'pending',
        description: _offerDesc,
        attachment: imageUrl,
        userId: widget.userId,
        requestId: widget.clientRequestInfo['requestId'],
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
}
