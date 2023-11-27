import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ClientActiveRequest.dart';
import 'package:laborlink/Pages/Client/Activity/ClientViewHistory.dart';
import 'package:laborlink/Widgets/Cards/HandymanHireCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanProposalCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanSelectedCard.dart';
import 'package:laborlink/Widgets/Cards/PendingRequestInfoCard.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/models/client.dart';

class ClientActivityPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  final String userId;
  const ClientActivityPage(
      {Key? key, required this.navigateToNewPage, required this.userId})
      : super(key: key);

  @override
  State<ClientActivityPage> createState() => _ClientActivityPageState();
}

class _ClientActivityPageState extends State<ClientActivityPage> {
  int _selectedTabIndex = 0;

  bool _haveActiveRequest = false;
  bool _havePendingOpenRequest = false;
  bool _havePendingDirectRequest = false;
  bool _forApproval = false;
  Request? requestInfo;
  DatabaseService service = DatabaseService();
  List<Map<String, dynamic>> interestedLaborer = [];
  List<Map<String, dynamic>> interestedLaborerWithOffer = [];
  List<Map<String, dynamic>> combinedInterestedLaborers = [];

  @override
  void initState() {
    super.initState();
    checkForRequests();
    fetchInterestedLaborers();
    fetchOffersOfLaborers();
  }

  void checkForRequests() async {
    try {
      requestInfo = await service.getRequestsData(widget.userId);

      String progress = requestInfo!.progress;
      print(progress);

      setState(() {
        if (progress == "pending") {
          _haveActiveRequest = false;
          _havePendingOpenRequest = true;
          _havePendingDirectRequest = true;
          _forApproval = true;
        }
      });
    } catch (error) {
      print('Error fetching user data:1 $error');
    }
  }

  void fetchInterestedLaborers() async {
    try {
      interestedLaborerWithOffer =
          await service.getInterestedHandymanAndOffer(widget.userId);
    } catch (error) {
      print('Error fetching interested laborers: $error');
    }
    // Combine the lists
    combinedInterestedLaborers.addAll(interestedLaborer);
    combinedInterestedLaborers.addAll(interestedLaborerWithOffer);
  }

  void fetchOffersOfLaborers() async {
    try {
      interestedLaborer = await service.getInterestedHandyman(widget.userId);
      print(interestedLaborer);
    } catch (error) {
      print('Error fetching interested laborers: $error');
    }
  }

  Future<Map<String, dynamic>> convertRequestToMap(Request request) async {
    Client? clientInfo;
    try {
      clientInfo = await service.getUserData(widget.userId);
    } catch (error) {
      print('Error fetching user data 2: $error');
    }
    print(clientInfo);

    // Implement the conversion logic based on the structure of Request
    return {
      'title': requestInfo!.title,
      'category': requestInfo!.category,
      'progress': requestInfo!.progress,
      'date': requestInfo!.date,
      'time': requestInfo!.time,
      'suggestedFee': requestInfo!.suggestedPrice,
      'address': clientInfo!.streetAddress,
      'userId': requestInfo!.userId,
    };
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
                        ? "Past Requests"
                        : "${_haveActiveRequest ? "Active" : "Pending"} Request",
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
    final noActiveRequest = !_haveActiveRequest &&
        !_havePendingOpenRequest &&
        !_havePendingDirectRequest;

    // IF NO ACTIVE OR PENDING REQUEST
    if (noActiveRequest) {
      return noRequest(deviceWidth);
    }

    // IF HAVE PENDING REQUEST
    if (_havePendingOpenRequest || _havePendingDirectRequest) {
      Widget tabContent;

      if (_havePendingOpenRequest && _forApproval) {
        tabContent = pendingApproval();
      } else if (_havePendingOpenRequest) {
        tabContent = pendingOpenRequest();
      } else {
        tabContent = pendingDirectRequest();
      }

      return Padding(
        padding: const EdgeInsets.only(top: 54),
        child: tabContent,
      );
    }

    // IF HAVE ACTIVE REQUEST
    return activeRequest();
  }

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
                  "Make a request today!",
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 25),
                ),
              ),
              Text(
                "You have no pending/active request\nat the moment",
                textAlign: TextAlign.center,
                style: getTextStyle(
                    textColor: AppColors.black,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 12),
              )
            ],
          ),
        ),
      );

  Widget pendingApproval() {
    return FutureBuilder<Map<String, dynamic>>(
      future: convertRequestToMap(requestInfo!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Return a loading indicator or placeholder
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle the error
        } else {
          Map<String, dynamic> requestDetail = snapshot.data!;

          return PendingRequestInfoCard(
            type: PendingRequestType.forApproval,
            requestDetail: requestDetail,
          );
        }
      },
    );
  }

  Widget pendingOpenRequest() {
    return FutureBuilder<Map<String, dynamic>>(
      future: convertRequestToMap(requestInfo!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Return a loading indicator or placeholder
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle the error
        } else {
          Map<String, dynamic> requestDetail = snapshot.data!;

          return Stack(
            children: [
              Container(
                color: AppColors.dirtyWhite,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 192),
                child: interestedLaborers(),
              ),
              PendingRequestInfoCard(
                type: PendingRequestType.openRequest,
                requestDetail: requestDetail,
              ),
            ],
          );
        }
      },
    );
  }

  Widget pendingDirectRequest() {
    return FutureBuilder<Map<String, dynamic>>(
      future: convertRequestToMap(requestInfo!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Return a loading indicator or placeholder
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle the error
        } else {
          Map<String, dynamic> requestDetail = snapshot.data!;

          return _buildPendingDirectRequest(requestDetail);
        }
      },
    );
  }

  Widget _buildPendingDirectRequest(Map<String, dynamic> requestDetail) {
    return Stack(
      children: [
        Container(
          color: AppColors.dirtyWhite,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 208),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Selected Handyman",
                  style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 9, top: 8),
                child: HandymanSelectedCard(
                  handymanInfo: dummyFilteredHandyman[4],
                ),
              ),
            ],
          ),
        ),
        PendingRequestInfoCard(
          type: PendingRequestType.directRequest,
          requestDetail: requestDetail,
        ),
      ],
    );
  }

  Widget activeRequest() => Padding(
        padding: const EdgeInsets.only(top: 54),
        child: FutureBuilder<Map<String, dynamic>>(
          future: convertRequestToMap(requestInfo!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return a loading indicator or placeholder
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle the error
              return Text('Error: ${snapshot.error}');
            } else {
              // Use the data from the snapshot
              Map<String, dynamic> requestDetail = snapshot.data!;

              return ClientActiveRequest(requestDetail: requestDetail);
            }
          },
        ),
      );

  Widget interestedLaborers() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Interested Laborers",
                style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: combinedInterestedLaborers.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> currentHandyman =
                      combinedInterestedLaborers[index];

                  // Check if the current handyman has an offer
                  bool hasOffer = currentHandyman.containsKey('bidPrice');

                  // Choose the appropriate card based on whether there's an offer or not
                  Widget card = hasOffer
                      ? HandymanProposalCard(handymanInfo: currentHandyman)
                      : HandymanHireCard(
                          handymanInfo: currentHandyman,
                          requestId: widget.userId);

                  return Padding(
                    padding:
                        EdgeInsets.only(top: index == 0 ? 5 : 0, bottom: 8),
                    child: card,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                              child: Text("Completed Requests",
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
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => ClientViewHistory(
                                      userId: widget.userId,
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
                              child: Text("Cancelled Requests",
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
                            itemCount: 10,
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
