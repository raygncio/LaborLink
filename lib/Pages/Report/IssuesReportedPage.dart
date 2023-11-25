import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/report.dart';
import 'package:laborlink/models/client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../dummyDatas.dart';

class IssuesReportedPage extends StatefulWidget {
  final String userId;
  const IssuesReportedPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<IssuesReportedPage> createState() => _IssuesReportedPageState();
}

class _IssuesReportedPageState extends State<IssuesReportedPage> {
  List<Report> issues = []; // This will hold your list of issues
  String fullName = "";

  @override
  void initState() {
    super.initState();
    // Call an async function to fetch data
    _loadData();
    fetchUserData();
  }

  // Define an async function to fetch data
  _loadData() async {
    // Use await to wait for the result
    // need ko ata i connect yung user id ng client sa user id ng reports?
    List<Report> reports = await getAllReportData(widget.userId);

    // Update the state with the result
    setState(() {
      issues = reports;
    });
  }

  Future<void> fetchUserData() async {
    DatabaseService service = DatabaseService();
    try {
      Client clientInfo = await service.getUserData(widget.userId);

      fullName = clientInfo.firstName +
          ' ' +
          (clientInfo.middleName ?? "") +
          ' ' +
          clientInfo.lastName +
          ' ' +
          (clientInfo.suffix ?? "");
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<List<Report>> getAllReportData(String userId) async {
    DatabaseService service = DatabaseService();
    try {
      List<Report> reports = await service.getAllReportData(widget.userId);
      return reports;
    } catch (error) {
      print('Error fetching user data 2: $error');
      // Return an empty list in case of an error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          color: AppColors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 74),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        issues.length, // Use the length of the issues list
                    itemBuilder: (context, index) {
                      Report report =
                          issues[index]; // Get the report at the current index

                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.secondaryBlue,
                                    width: 0.5))),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 23, top: 12.64),
                                  child: Row(
                                    children: [
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets.only(right: 11),
                                      //   child: ClipOval(
                                      //     child: Image.network(
                                      //       report.proof, // Use report data
                                      //       width: 64,
                                      //       height: 64,
                                      //     ),
                                      //   ),
                                      // ),
                                      Column(
                                        children: [
                                          Text(
                                            fullName,
                                            style: getTextStyle(
                                                textColor:
                                                    AppColors.secondaryBlue,
                                                fontFamily: AppFonts.montserrat,
                                                fontWeight: AppFontWeights.bold,
                                                fontSize: 15),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 3),
                                                child: Container(
                                                  height: 12.35,
                                                  width: 12.35,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.dirtyWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  // child: Image.asset(
                                                  //   report
                                                  //       .proof, // Use report data
                                                  // ),
                                                ),
                                              ),
                                              // Text(
                                              //   report
                                              //       .issueType, // Use report data
                                              //   style: getTextStyle(
                                              //       textColor:
                                              //           AppColors.secondaryBlue,
                                              //       fontFamily:
                                              //           AppFonts.montserrat,
                                              //       fontWeight:
                                              //           AppFontWeights.bold,
                                              //       fontSize: 10),
                                              // ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2.82),
                                            child: AppBadge(
                                              label:
                                                  "Request ID: ${report.reportId}", // Use report data
                                              type: BadgeType.normal,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7, vertical: 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 28, right: 17, top: 14.65),
                                //   child: LayoutBuilder(
                                //     builder: (context, constraints) {
                                //       double columnWidth =
                                //           constraints.maxWidth / 2;

                                //       return Row(
                                //         children: [
                                //           SizedBox(
                                //             width: columnWidth,
                                //             child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 TextWithIcon(
                                //                   icon: Icon(Icons.place,
                                //                       size: 13,
                                //                       color: AppColors
                                //                           .accentOrange),
                                //                   text: report
                                //                       .location, // Use report data
                                //                   fontSize: 9,
                                //                   contentPadding: 8,
                                //                 ),
                                //                 Padding(
                                //                   padding: EdgeInsets.only(
                                //                       top: 6.75),
                                //                   child: TextWithIcon(
                                //                     icon: Icon(
                                //                         Icons
                                //                             .local_offer_rounded,
                                //                         size: 13,
                                //                         color: AppColors
                                //                             .accentOrange),
                                //                     text:
                                //                         "₱${report.cost}", // Use report data
                                //                     fontSize: 9,
                                //                     contentPadding: 8,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: columnWidth,
                                //             child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 TextWithIcon(
                                //                   icon: Icon(
                                //                       Icons
                                //                           .calendar_month_rounded,
                                //                       size: 13,
                                //                       color: AppColors
                                //                           .accentOrange),
                                //                   text: report
                                //                       .date, // Use report data
                                //                   fontSize: 9,
                                //                   contentPadding: 8,
                                //                 ),
                                //                 Padding(
                                //                   padding: EdgeInsets.only(
                                //                       top: 6.75),
                                //                   child: TextWithIcon(
                                //                     icon: Icon(
                                //                         Icons.watch_later,
                                //                         size: 13,
                                //                         color: AppColors
                                //                             .accentOrange),
                                //                     text: report
                                //                         .time, // Use report data
                                //                     fontSize: 9,
                                //                     contentPadding: 8,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           )
                                //         ],
                                //       );
                                //     },
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 28,
                                      right: 17,
                                      top: 8.27,
                                      bottom: 19),
                                  child: Text(
                                    report.issue, // Use report data
                                    overflow: TextOverflow.visible,
                                    style: getTextStyle(
                                        textColor: AppColors.black,
                                        fontFamily: AppFonts.montserrat,
                                        fontWeight: AppFontWeights.regular,
                                        fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 15,
                              right: 17,
                              child: reportBadge("Waiting"),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
              Align(alignment: Alignment.topCenter, child: appBar(deviceWidth)),
            ],
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar(deviceWidth) => Container(
        color: AppColors.secondaryBlue,
        height: 74,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              height: 23,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: onBack,
                        child: Image.asset("assets/icons/back-btn-2.png",
                            height: 23,
                            width: 13,
                            alignment: Alignment.centerLeft),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Issues Reported",
                      style: getTextStyle(
                          textColor: AppColors.secondaryYellow,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget reportBadge(String status) {
    Color? bgColor;
    if (status == "Waiting") {
      bgColor = AppColors.secondaryBlue;
    } else if (status == "Resolved") {
      bgColor = AppColors.green;
    } else if (status == "Approved") {
      bgColor = AppColors.accentOrange;
    } else {
      bgColor = AppColors.dirtyWhite;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 88,
          height: 25,
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(status,
                style: getTextStyle(
                    textColor: status == "Returned"
                        ? AppColors.black
                        : AppColors.white,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12)),
          ),
        ),
        Visibility(
          visible: status == "Approved",
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: SizedBox(
              width: 119,
              child: Text(
                  "Expect a customer representative to call you within the days",
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.right,
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 7)),
            ),
          ),
        )
      ],
    );
  }
}
