import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ClientActiveRequest.dart';
import 'package:laborlink/Pages/Client/Activity/ClientViewHistory.dart';
import 'package:laborlink/Widgets/Cards/HandymanHireCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanProposalCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanSelectedCard.dart';
import 'package:laborlink/Widgets/Cards/PendingRequestInfoCard.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/styles.dart';
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
  String checkRequest = '';
  Request? requestInfo;
  DatabaseService service = DatabaseService();
  List<Map<String, dynamic>> interestedLaborer = [];
  List<Map<String, dynamic>> interestedLaborerWithOffer = [];
  List<Map<String, dynamic>> combinedInterestedLaborers = [];
  Map<String, dynamic> getActiveRequest = {};
  Map<String, dynamic> getDirectInfo = {};
  Future<Map<String, dynamic>>? activeRequestFuture;

  @override
  void initState() {
    super.initState();
    checkForRequests();
    fetchInterestedLaborers();
    fetchOffersOfLaborers();
    activeRequestFuture = getTheActiveRequest();
  }

  void checkForRequests() async {
    bool direct = false;
    try {
      requestInfo = await service.getRequestsData(widget.userId);

      String progress = requestInfo!.progress;
      String? handymanId = requestInfo?.handymanId;
      // print('progress: $progress');

      setState(() {
        if (progress == "pending" && handymanId != null) {
          _havePendingDirectRequest = true;
          // _forApproval = true;
          checkRequest = "direct";
          direct = true;
        } else if (progress == "pending") {
          _havePendingOpenRequest = true;
          checkRequest = "open";
        } else if (progress == "hired" ||
            progress == "omw" ||
            progress == "arrived" ||
            progress == "inprogress" ||
            progress == "completion") {
          _haveActiveRequest = true;
        }
      });

      if (direct) {
        getDirectRequest();
      }
    } catch (error) {
      print('Error fetching get user data: $error');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Error fetching get user data."),
      //     backgroundColor: Colors.red,
      //   ),
      // );

    }
  }

  void getDirectRequest() async {
    try {
      getDirectInfo = await service.getDirectRequest(
          widget.userId); // print("GET THE DIRECT INFO: $getDirectInfo");
      setState(() {
        getDirectInfo = getDirectInfo;
      });
    } catch (error) {
      // print('Error fetching interested laborers: 1 $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching interested laborers."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void fetchInterestedLaborers() async {
    try {
      interestedLaborerWithOffer =
          await service.getInterestedHandymanAndOffer(widget.userId);
      // print(interestedLaborerWithOffer);
    } catch (error) {
      // print('Error fetching interested laborers: 2 $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching interested laborers."),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (interestedLaborerWithOffer.isNotEmpty) {
      // Combine the lists
      setState(() {
        combinedInterestedLaborers.addAll(interestedLaborerWithOffer);
      });
    }
  }

  Future<Map<String, dynamic>> getTheActiveRequest() async {
    try {
      return await service.getActiveRequest(widget.userId);
      
    } catch (error) {
      // print('Error fetching active request: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching active request."),
          backgroundColor: Colors.red,
        ),
      );
      return {};
    }
  }

  void fetchOffersOfLaborers() async {
    try {
      interestedLaborer = await service.getInterestedHandyman(widget.userId);
      // print(
      //     "*************************CHECK THE INTERESTED LABORER $interestedLaborer");
    } catch (error) {
      // print('Error fetching interested laborers: 3 $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching interested laborers."),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (interestedLaborer.isNotEmpty) {
      setState(() {
        combinedInterestedLaborers.addAll(interestedLaborer);
      });
    }

    // print(
    //     "*************************CHECK THE COMBINE 2 ${combinedInterestedLaborers.length}");
    // print(
    //     "*************************CHECK THE COMBINE 2 NEW $combinedInterestedLaborers");
  }

  Future<Map<String, dynamic>> convertRequestToMap(Request request) async {
    Client? clientInfo;
    try {
      clientInfo = await service.getUserData(widget.userId);
    } catch (error) {
      // print('Error fetching user data 2: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching user data."),
          backgroundColor: Colors.red,
        ),
      );
    }
    // print(clientInfo);

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
          return const CircularProgressIndicator(); // Return a loading indicator or placeholder
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
          return const CircularProgressIndicator(); // Return a loading indicator or placeholder
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
          return const CircularProgressIndicator(); // Return a loading indicator or placeholder
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle the error
        } else {
          Map<String, dynamic> requestDetail = snapshot.data!;

          return FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 400)),
            builder: (context, delaySnapshot) {
              if (delaySnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Return a loading indicator or placeholder during the delay
              } else {
                return _buildPendingDirectRequest(requestDetail);
              }
            },
          );
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
                  handymanInfo: getDirectInfo,
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

  Widget activeRequest() {
    return FutureBuilder<Map<String, dynamic>>(
      future: activeRequestFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> getActiveRequest = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 54),
            child: ClientActiveRequest(requestDetail: getActiveRequest),
          );
        }
      },
    );
  }

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
                  // print(
                  //     "*************************CHECK THE CURRENT HANDYMAN ${combinedInterestedLaborers.length}");

                  // Check if the current handyman has an offer
                  bool hasOffer = currentHandyman.containsKey('bidPrice');

                  // print(
                  //     '>>>>>>>>>>>>>>>>>>> HAS OFFER ${currentHandyman.containsKey('suggestedPrice')}');
                  if (hasOffer) {
                    return HandymanProposalCard(handymanInfo: currentHandyman);
                  } else if (currentHandyman.containsKey('suggestedPrice')) {
                    // print("checking");
                    // print(currentHandyman['specialization']);
                    return HandymanHireCard(
                        handymanInfo: currentHandyman,
                        requestId: widget.userId);
                  } else {}

                  // // Choose the appropriate card based on whether there's an offer or not
                  // Widget card = hasOffer
                  //     ? HandymanProposalCard(handymanInfo: currentHandyman)
                  //     : HandymanHireCard(
                  //         handymanInfo: currentHandyman,
                  //         requestId: widget.userId);

                  return Padding(
                    padding:
                        EdgeInsets.only(top: index == 0 ? 5 : 0, bottom: 8),
                    //child: card,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> historyTab(deviceWidth) async {
    // get the request, completed and cancelled
    bool openCompletedRequest = false;
    bool openCancelledRequest = false;
    List<Map<String, dynamic>> cancelledRequest = [];
    List<Map<String, dynamic>> completedRequest = [];
    // print(widget.userId);

    try {
      completedRequest = await service.getCompletedRequest(widget.userId);
      cancelledRequest = await service.getCancelledRequest(widget.userId);
      //print('*************************COMPLETED REQUEST $completedRequest');
      // print('*************************CANCELLED REQUEST $cancelledRequest');
    } catch (error) {
      // print('Error fetching interested laborers: 4 $error');
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

    // print(
    //     '*************************CHECK THE BOOLEAN FOR CANCELLED REQUEST $openCompletedRequest');

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
                            itemCount: completedRequest.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> currentRequest =
                                  completedRequest[index];
                              // print(
                              //     ">>>>>>>>>>>>${currentRequest['validRequestId']}");
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
                                            currentCancelledRequest[
                                                    'suggestedPrice']
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
}
