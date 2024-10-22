import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ClientViewHistory.dart';
import 'package:laborlink/Pages/Handyman/Activity/HandymanActiveRequest.dart';
import 'package:laborlink/Pages/Handyman/Activity/ViewOfferPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Cards/ClientInfoCard.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/styles.dart';

import '../../../Widgets/Badge.dart';

class HandymanActivityPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  final String userId;
  const HandymanActivityPage(
      {Key? key, required this.navigateToNewPage, required this.userId})
      : super(key: key);

  @override
  State<HandymanActivityPage> createState() => _HandymanActivityPageState();
}

class _HandymanActivityPageState extends State<HandymanActivityPage> {
  int _selectedTabIndex = 0;
  Map<String, dynamic> getActiveRequest = {};
  Map<String, dynamic> getClientRequest = {};
  DatabaseService service = DatabaseService();

  bool _haveActiveRequest = false;
  bool _forApproval = false;

  @override
  void initState() {
    super.initState();
    checkForRequests();
    // fetchInterestedLaborers();
  }

  void checkForRequests() async {
    try {
      getActiveRequest = await service.getActiveRequestHandyman(widget.userId);
      getClientRequest = await service.getActiveRequestClient(widget.userId);
      // print("testingggggggg ${getActiveRequest['activeRequestId']}");
      setState(() {
        if (getActiveRequest["approvalStatus"] == "pending") {
          _forApproval = true;
        } else if (getActiveRequest["progress"] == "hired" ||
            getActiveRequest["progress"] == "omw" ||
            getActiveRequest["progress"] == "arrived" ||
            getActiveRequest["progress"] == "inprogress" ||
            getActiveRequest["progress"] == "completion" ||
            getActiveRequest["progress"] == "rating") {
          _haveActiveRequest = true;
        }
      });
    } catch (error) {
      print('Error fetching user data:1 $error');
    }
  }

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
    if (_selectedTabIndex == 0) {
      return ongoingTab(deviceWidth);
    } else {
      return FutureBuilder<Widget>(
        future: historyTab(deviceWidth),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Return a loading indicator or placeholder
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Handle the error
          } else {
            return snapshot.data ?? const SizedBox.shrink();
          }
        },
      );
    }
  }

  Widget ongoingTab(deviceWidth) {
    final noActiveRequest = !_haveActiveRequest && !_forApproval;

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
            ViewClientProposal(handymanInfo: getActiveRequest),
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
                      // Wrap the Text widget with Container for fixed width
                Container(
                  width: 170, // Set your specific width here
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      getActiveRequest['title'],
                      style: getTextStyle(
                          textColor: AppColors.tertiaryBlue,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 17),
                    ),
                  ),
                ),
                      const AppBadge(
                          label: "Waiting for approval",
                          type: BadgeType.blocked,
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 2)),
                      AppOutlinedButton(
                          height: 20,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          text: "Cancel request",
                          textStyle: getTextStyle(
                              textColor: AppColors.accentOrange,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 8),
                          color: AppColors.accentOrange,
                          command: onCancelRequest,
                          borderRadius: 8,
                          borderWidth: 1),
                    ],
                  ),
                  Text(
                    "Request ID:${getActiveRequest['activeRequestId']}",
                    style: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.regular,
                        fontSize: 13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Text(
                      getActiveRequest['description'],
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200, // Set your specific width here
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: TextWithIcon(
                                  icon: const Icon(
                                    Icons.place,
                                    size: 17,
                                    color: AppColors.accentOrange,
                                  ),
                                  text: getActiveRequest['address'],
                                  fontSize: 12,
                                  contentPadding: 19,
                                ),
                              ),
                            ),
                            // TextWithIcon(
                            //   icon: const Icon(Icons.place,
                            //       size: 17, color: AppColors.accentOrange),
                            //   text: getActiveRequest['address'],
                            //   fontSize: 12,
                            //   contentPadding: 19,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextWithIcon(
                                icon: const Icon(Icons.calendar_month_rounded,
                                    size: 17, color: AppColors.accentOrange),
                                text: getActiveRequest['date'],
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextWithIcon(
                                icon: const Icon(Icons.watch_later,
                                    size: 17, color: AppColors.accentOrange),
                                text: getActiveRequest['time'],
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextWithIcon(
                                icon: const Icon(Icons.local_offer_rounded,
                                    size: 17, color: AppColors.accentOrange),
                                text: getActiveRequest['suggestedPrice']
                                    .toString(),
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (getActiveRequest['hasOffer'] == true)
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
                              Padding(
                                padding: const EdgeInsets.only(top: 7.76),
                                child: AppBadge(
                                  label:
                                      "Offered ₱${getActiveRequest['bidPrice'].toString()}",
                                  type: BadgeType.offer,
                                  padding: const EdgeInsets.symmetric(
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
                              getActiveRequest['attachment'],
                              height: 160,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 4.5),
                        //     child: Image.network(
                        //       getActiveRequest['attachment'],
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54),
            child: ClientInfoCard(clientInfo: getClientRequest),
          ),
        ],
      );

  Widget activeRequest() {
    return FutureBuilder(
      future: Future.delayed(
          const Duration(seconds: 1)), // Adjust the delay duration as needed
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.only(top: 54),
            child: HandymanActiveRequest(
                requestDetail: getActiveRequest,
                clientDetail: getClientRequest),
          );
        } else {
          // Return a loading indicator or an empty container while waiting
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<Widget> historyTab(deviceWidth) async {
    bool openCompletedRequest = false;
    bool openCancelledRequest = false;

    List<Map<String, dynamic>> cancelledRequest = [];
    List<Map<String, dynamic>> completedRequest = [];

    try {
      completedRequest =
          await service.getCompletedRequestHandyman(widget.userId);
      cancelledRequest =
          await service.getCancelledRequestHandyman(widget.userId);
      //print('*************************COMPLETED REQUEST $completedRequest');

      // print('*************************CANCELLED REQUEST $cancelledRequest');
    } catch (error) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching interested laborers."),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (completedRequest.isNotEmpty) {
      openCompletedRequest = true;
    }

    if (cancelledRequest.isNotEmpty) {
      openCancelledRequest = true;
    }

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
                            itemCount: completedRequest.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> currentRequest =
                                  completedRequest[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => ClientViewHistory(
                                      userId: currentRequest['validRequestId'],
                                      userRole: currentRequest['userRole'],
                                    ),
                                  )),
                                  child: Container(
                                    height: 52,
                                    color: AppColors.white,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Image.asset(
                                            "assets/icons/${currentRequest['category'].toString().toLowerCase()}.png",
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
                                                  currentRequest['title'] ?? '',
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
                                              "${currentRequest['date']}${','}${currentRequest['time']}",
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
                                              currentRequest['suggestedPrice']
                                                  .toString(),
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
                            itemCount: cancelledRequest.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> currentCancelledRequest =
                                  cancelledRequest[index];
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
                                          "assets/icons/${currentCancelledRequest['category'].toString().toLowerCase()}.png",
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
                                                currentCancelledRequest[
                                                    'title'],
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
                                            "${currentCancelledRequest['date']}${','}${currentCancelledRequest['time']}",
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
                                            currentCancelledRequest['bidPrice']
                                                .toString(),
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

  void onCancelRequest() async {
    bool confirmCancel = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Request'),
          content: const Text('Are you sure you want to cancel your request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
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

    if (confirmCancel == true) {
      DatabaseService service = DatabaseService();

      try {
        await service.cancelApproval(widget.userId);
        // print('Document updated successfully');
        // Show SnackBar when request is successfully cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your request has been successfully cancelled'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.tertiaryBlue,
          ),
        );
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HandymanMainPage(userId: widget.userId),
        ));
      } catch (e) {
        // print('Error updating document: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating document."),
          backgroundColor: Colors.red,
        ),
      );
      }
    }
  }
}
