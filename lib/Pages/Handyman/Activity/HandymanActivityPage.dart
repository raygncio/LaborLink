import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ClientActiveRequest.dart';
import 'package:laborlink/Pages/Client/Activity/ClientViewHistory.dart';
import 'package:laborlink/Pages/Handyman/Activity/HandymanActiveRequest.dart';
import 'package:laborlink/Pages/Handyman/Activity/ViewOfferPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Cards/ClientInfoCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanHireCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanProposalCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanSelectedCard.dart';
import 'package:laborlink/Widgets/Cards/PendingRequestInfoCard.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

import '../../../Widgets/Badge.dart';

class HandymanActivityPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  const HandymanActivityPage({Key? key, required this.navigateToNewPage})
      : super(key: key);

  @override
  State<HandymanActivityPage> createState() => _HandymanActivityPageState();
}

class _HandymanActivityPageState extends State<HandymanActivityPage> {
  int _selectedTabIndex = 0;

  bool _haveActiveRequest = true;
  bool _forApproval = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(deviceWidth),
              Expanded(
                child: Stack(
                  children: [
                    displayTabContent(deviceWidth),
                    AppTabNavBar(
                        selectedTabIndex: _selectedTabIndex,
                        leftLabel: "Ongoing",
                        rightLabel: "History",
                        onChanged: updateSelectedTab),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateSelectedTab(int selectedTabIndex) {
    setState(() {
      _selectedTabIndex = selectedTabIndex;
    });
  }

  Widget header(deviceWidth) => Container(
        width: deviceWidth,
        height: 96,
        color: AppColors.secondaryBlue,
        child: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 33),
                child: Text(
                    _selectedTabIndex == 1
                        ? "Past Services"
                        : _haveActiveRequest
                            ? "Active Request"
                            : "Pending Services",
                    style: getTextStyle(
                        textColor: AppColors.secondaryYellow,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 30)),
              ),
            ],
          ),
        ),
      );

  Widget displayTabContent(deviceWidth) {
    return _selectedTabIndex == 0
        ? ongoingTab(deviceWidth)
        : historyTab(deviceWidth);
  }

  Widget ongoingTab(deviceWidth) {
    final noActiveRequest = !_haveActiveRequest;

    // IF NO ACTIVE REQUEST
    if (noActiveRequest) {
      return noRequest(deviceWidth);
    }

    // IF FOR APPROVAL
    if (_forApproval) {
      return pendingApproval();
    }

    // IF HAVE ACTIVE REQUEST
    return activeRequest();
  }

  void onViewOffer() => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ViewClientProposal(handymanInfo: dummyFilteredHandyman[0]),
      ));

  Widget noRequest(deviceWidth) => Padding(
        padding: const EdgeInsets.only(top: 54),
        child: SizedBox(
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 59, right: 58, top: 54),
                child: Image.asset("assets/icons/handyman.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "Look for a labor today!",
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 25),
                ),
              ),
              Text(
                "You have no ongoing service/s\nat the moment",
                textAlign: TextAlign.center,
                style: getTextStyle(
                    textColor: AppColors.black,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 39),
                child: SizedBox(
                  width: 147,
                  child: Row(
                    children: [
                      AppFilledButton(
                          text: "Home",
                          fontSize: 15,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.secondaryBlue,
                          command: () => widget.navigateToNewPage(0),
                          borderRadius: 8)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget pendingApproval() => Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(top: 150, left: 25, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "Request Title",
                          style: getTextStyle(
                              textColor: AppColors.tertiaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 17),
                        ),
                      ),
                      const AppBadge(
                          label: "Waiting for approval",
                          type: BadgeType.blocked,
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 2)),
                    ],
                  ),
                  Text(
                    "Request ID",
                    style: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.regular,
                        fontSize: 13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Text(
                      "I'm experiencing a clogged sink issue in my kitchen that requires attention. The clog seems to be located near the drain area and has been causing slow drainage over the past few days.",
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
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
                                text: "Today",
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
                                text: "₱550",
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 71,
                              child: Row(
                                children: [
                                  AppFilledButton(
                                      height: 20,
                                      text: "View Offer",
                                      fontSize: 9,
                                      fontFamily: AppFonts.montserrat,
                                      color: AppColors.secondaryBlue,
                                      command: onViewOffer,
                                      borderRadius: 8),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 7.76),
                              child: AppBadge(
                                label: "Offered ₱650",
                                type: BadgeType.offer,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.5),
                            child: Image.network(
                              imgPlaceholder,
                              height: 101,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.5),
                            child: Image.network(
                              imgPlaceholder,
                              height: 101,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54),
            child: ClientInfoCard(clientInfo: dummyClients[0]),
          ),
        ],
      );

  Widget activeRequest() => Padding(
        padding: const EdgeInsets.only(top: 54),
        child: HandymanActiveRequest(requestDetail: dummyActiveRequest[0]),
      );

  Widget historyTab(deviceWidth) {
    bool openCompletedRequest = true;
    bool openCancelledRequest = true;

    return Padding(
      padding: const EdgeInsets.only(top: 54),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double scrollableSectionHeight = (constraints.maxHeight - 90) / 2;

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          openCompletedRequest = !openCompletedRequest;
                        }),
                        child: Container(
                          height: 45,
                          width: deviceWidth,
                          decoration: const BoxDecoration(
                              color: AppColors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5,
                                      color: AppColors.secondaryBlue))),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 28, bottom: 8),
                              child: Text("Completed Services",
                                  style: getTextStyle(
                                      textColor: AppColors.secondaryBlue,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.regular,
                                      fontSize: 10)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: openCompletedRequest,
                        child: SizedBox(
                          height: scrollableSectionHeight,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 52,
                                    color: AppColors.white,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Image.asset(
                                            "assets/icons/plumbing.png",
                                            height: 32,
                                            width: 32,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "My sink is leaking!",
                                                  style: getTextStyle(
                                                      textColor: AppColors
                                                          .secondaryBlue,
                                                      fontFamily:
                                                          AppFonts.montserrat,
                                                      fontWeight:
                                                          AppFontWeights.bold,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "07 Aug 2023, 11:12 AM",
                                              style: getTextStyle(
                                                  textColor:
                                                      AppColors.secondaryBlue,
                                                  fontFamily:
                                                      AppFonts.montserrat,
                                                  fontWeight:
                                                      AppFontWeights.regular,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          height: 32,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "₱650.00",
                                              style: getTextStyle(
                                                  textColor:
                                                      AppColors.secondaryBlue,
                                                  fontFamily:
                                                      AppFonts.montserrat,
                                                  fontWeight:
                                                      AppFontWeights.bold,
                                                  fontSize: 8),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          openCancelledRequest = !openCancelledRequest;
                        }),
                        child: Container(
                          height: 45,
                          width: deviceWidth,
                          decoration: const BoxDecoration(
                              color: AppColors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5,
                                      color: AppColors.secondaryBlue))),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 28, bottom: 8),
                              child: Text("Cancelled Services",
                                  style: getTextStyle(
                                      textColor: AppColors.secondaryBlue,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.regular,
                                      fontSize: 10)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: openCancelledRequest,
                        child: SizedBox(
                          height: scrollableSectionHeight,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 0,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: SizedBox(
                                  height: 52,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Image.asset(
                                          "assets/icons/pest-2.png",
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Roaches everywhere",
                                                style: getTextStyle(
                                                    textColor: AppColors.grey,
                                                    fontFamily:
                                                        AppFonts.montserrat,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "15 June 2023, 10:48 AM",
                                            style: getTextStyle(
                                                textColor: AppColors.grey,
                                                fontFamily: AppFonts.montserrat,
                                                fontWeight:
                                                    AppFontWeights.regular,
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 32,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            "₱700.00",
                                            style: getTextStyle(
                                                textColor: AppColors.grey,
                                                fontFamily: AppFonts.montserrat,
                                                fontWeight: AppFontWeights.bold,
                                                fontSize: 8),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
