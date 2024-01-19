import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';

import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';

class ViewHandymanProposal extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const ViewHandymanProposal({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<ViewHandymanProposal> createState() => _ViewHandymanProposalState();
}

class _ViewHandymanProposalState extends State<ViewHandymanProposal> {
  late double bidPrice;
  late double suggestedPrice;
  late double addCharge;
  late double serviceFee;
  late double convenienceFee;
  final DatabaseService service = DatabaseService();

  @override
  Widget build(BuildContext context) {
    bidPrice = (widget.handymanInfo["bidPrice"] as num).toDouble();
    suggestedPrice = (widget.handymanInfo["suggestedPrice"] as num).toDouble();
    addCharge = bidPrice - suggestedPrice;
    serviceFee = suggestedPrice / 1.10;
    convenienceFee = suggestedPrice - serviceFee;

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(),
              Expanded(
                child: Container(
                  color: AppColors.white,
                  child: Stack(
                    children: [
                      proposalSection(),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: totalSection()),
                      HandymanInfoCard(handymanInfo: widget.handymanInfo),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Padding(
        padding: const EdgeInsets.only(left: 17.8, bottom: 23, top: 27),
        child: GestureDetector(
          onTap: onBack,
          child: Image.asset("assets/icons/back-btn-2.png",
              height: 12.86, width: 23),
        ),
      );

  Widget proposalSection() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100, left: 28, right: 34, bottom: 227 + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      "Proposal",
                      style: getTextStyle(
                          textColor: AppColors.secondaryBlue,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 15),
                    ),
                  ),
                  AppBadge(
                    label:
                        "Offered ₱${widget.handymanInfo['bidPrice'].toString()}",
                    type: BadgeType.offer,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.handymanInfo["description"],
                  overflow: TextOverflow.visible,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Image.network(
                    widget.handymanInfo["attachment"],
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 16),
              //   child: GridView.builder(
              //     physics: const NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       crossAxisSpacing: 11,
              //       mainAxisSpacing: 11,
              //     ),
              //     itemCount: proposalImg.length,
              //     itemBuilder: (context, index) {
              //       return Image.asset(
              //         proposalImg[index],
              //         width: 140,
              //         height: 140,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      );

  Widget totalSection() => Container(
        height: 227,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 6),
                blurRadius: 12,
                color: AppColors.blackShadow,
              )
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 14, right: 14, top: 11, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "New Total",
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      ),
                      const Spacer(),
                      Text(
                        widget.handymanInfo["bidPrice"].toString(),
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Text(
                          "Service Fee",
                          style: getTextStyle(
                              textColor: AppColors.black,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.regular,
                              fontSize: 11),
                        ),
                        const Spacer(),
                        Text(
                          serviceFee.toDouble().toStringAsFixed(2),
                          style: getTextStyle(
                              textColor: AppColors.black,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.regular,
                              fontSize: 11),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Text(
                          "Convenience Fee",
                          style: getTextStyle(
                              textColor: AppColors.black,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.regular,
                              fontSize: 11),
                        ),
                        const Spacer(),
                        Text(
                          convenienceFee.toDouble().toStringAsFixed(2),
                          style: getTextStyle(
                              textColor: AppColors.black,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.regular,
                              fontSize: 11),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Text(
                          "Addt’l charges (offer)",
                          style: getTextStyle(
                              textColor: AppColors.pink,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.regular,
                              fontSize: 11),
                        ),
                        const Spacer(),
                        Text(
                          addCharge.toString(),
                          style: getTextStyle(
                              textColor: AppColors.pink,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.regular,
                              fontSize: 11),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 0,
                color: AppColors.greyD9,
                thickness: 0.7,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 14, top: 14, bottom: 14),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWithIcon(
                        icon: const Icon(Icons.place,
                            size: 17, color: AppColors.accentOrange),
                        text: widget.handymanInfo["address"],
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextWithIcon(
                          icon: const Icon(Icons.calendar_month_rounded,
                              size: 17, color: AppColors.accentOrange),
                          text: widget.handymanInfo["date"],
                          fontSize: 12,
                          contentPadding: 19,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextWithIcon(
                          icon: const Icon(Icons.watch_later,
                              size: 17, color: AppColors.accentOrange),
                          text: widget.handymanInfo["time"],
                          fontSize: 12,
                          contentPadding: 19,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextWithIcon(
                          icon: const Icon(Icons.local_offer_rounded,
                              size: 17, color: AppColors.accentOrange),
                          text:
                              "${widget.handymanInfo['bidPrice'].toString()}*",
                          fontSize: 12,
                          contentPadding: 19,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      width: 147,
                      child: Row(
                        children: [
                          AppFilledButton(
                              height: 37,
                              text: "Hire",
                              fontSize: 15,
                              fontFamily: AppFonts.montserrat,
                              color: AppColors.accentOrange,
                              command: hireHandyman,
                              borderRadius: 8),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  void hireHandyman() async {
    bool confirmHire = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hire Handyman'),
          content: const Text('Are you sure you want to hire this handyman?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print(widget.handymanInfo['handymanId']);
                print(widget.handymanInfo['NewRequestId']);
                print(widget.handymanInfo['bidPrice']);
                Navigator.of(context)
                    .pop(false); // Return false when cancel is pressed
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when confirm is pressed
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmHire == true) {
      try {
        await service.updateOffer(widget.handymanInfo['handymanId']);
        await service.updateRequestProgressWithOffer(
            widget.handymanInfo['NewRequestId'],
            widget.handymanInfo['handymanId'],
            widget.handymanInfo['bidPrice']);

        // Show SnackBar when request is successfully cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Handyman hired successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.tertiaryBlue,
          ),
        );

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ClientMainPage(userId: widget.handymanInfo['clientId']),
        ));
      } catch (e) {
        print('Error updating document: $e');
      }
    }
  }
}
