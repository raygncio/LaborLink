import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/ReviewCard.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

class ViewClientProposal extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const ViewClientProposal({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<ViewClientProposal> createState() => _ViewClientProposalState();
}

class _ViewClientProposalState extends State<ViewClientProposal> {
  @override
  Widget build(BuildContext context) {
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
              height: 23, width: 12.86),
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
                  const AppBadge(
                    label: "Offered ₱650",
                    type: BadgeType.offer,
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  loremIpsumLong,
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
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 11,
                  ),
                  itemCount: proposalImg.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      proposalImg[index],
                      width: 140,
                      height: 140,
                    );
                  },
                ),
              ),
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
                        "₱650.00",
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
                          "₱500.00",
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
                          "₱50.00",
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
                          "₱100.00",
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
            const Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 14, top: 14, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWithIcon(
                    icon: Icon(Icons.place,
                        size: 17, color: AppColors.accentOrange),
                    text: "556 Juan Luna Ave.",
                    fontSize: 12,
                    contentPadding: 19,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: TextWithIcon(
                      icon: Icon(Icons.calendar_month_rounded,
                          size: 17, color: AppColors.accentOrange),
                      text: "07 Aug 2023",
                      fontSize: 12,
                      contentPadding: 19,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: TextWithIcon(
                      icon: Icon(Icons.watch_later,
                          size: 17, color: AppColors.accentOrange),
                      text: "12:00 - 1:00 PM",
                      fontSize: 12,
                      contentPadding: 19,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: TextWithIcon(
                      icon: Icon(Icons.local_offer_rounded,
                          size: 17, color: AppColors.accentOrange),
                      text: "₱650*",
                      fontSize: 12,
                      contentPadding: 19,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
