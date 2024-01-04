import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/ReportIssueButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';

class ClientViewHistory extends StatefulWidget {
  final String userId;
  const ClientViewHistory({Key? key, required this.userId}) : super(key: key);

  @override
  State<ClientViewHistory> createState() => _ClientViewHistoryState();
}

class _ClientViewHistoryState extends State<ClientViewHistory> {
  Map<String, dynamic> completedRequest = {};
  double serviceFee = 0.0;
  double convenienceFee = 0.0;
  @override
  void initState() {
    super.initState();
    fetchUserData().then((data) {
      setState(() {
        completedRequest = data;
        serviceFee = completedRequest['suggestedFee'] / 1.10;
        convenienceFee = completedRequest['suggestedFee'] - serviceFee;
      });
    });
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    DatabaseService service = DatabaseService();

    try {
      completedRequest = await service.getClientHistory(widget.userId);
      print(completedRequest);
    } catch (error) {
      print('Error fetching interested laborers: $error');
    }

    return completedRequest;
  }

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
              appBar(deviceWidth),
              Expanded(
                child: Container(
                  color: AppColors.white,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            serviceSummary(deviceWidth),
                            totalSection(),
                          ],
                        ),
                      ),
                      HandymanInfoCard(handymanInfo: completedRequest),
                      const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 26),
                            child: ReportIssueButton(),
                          )),
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

  Widget appBar(deviceWidth) => SizedBox(
        height: 73,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22),
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
                    // child: Text(
                    //   "Request ID: 12345",
                    //   style: getTextStyle(
                    //       textColor: AppColors.secondaryYellow,
                    //       fontFamily: AppFonts.montserrat,
                    //       fontWeight: AppFontWeights.bold,
                    //       fontSize: 16),
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget serviceSummary(deviceWidth) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          width: deviceWidth,
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
                padding: const EdgeInsets.only(top: 13),
                child: Text(completedRequest['title'] ?? '',
                    style: getTextStyle(
                        textColor: AppColors.secondaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 15)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 41, vertical: 11),
                child: Text(
                  completedRequest['description'] ?? '',
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 7),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Divider(
                      color: AppColors.greyD9,
                      height: 0,
                      thickness: 0.7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double containerWidth =
                              constraints.maxWidth / 2 - 0.35;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: containerWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "BEFORE".split("").join("\n"),
                                        style: getTextStyle(
                                            textColor: AppColors.grey,
                                            fontFamily: AppFonts.montserrat,
                                            fontWeight: AppFontWeights.regular,
                                            fontSize: 15),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 21),
                                        child: Image.network(
                                          completedRequest['atttachment'] ?? '',
                                          width: 107,
                                          height: 107,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: AppColors.black,
                                width: 0.7,
                                height: 123,
                              ),
                              SizedBox(
                                width: containerWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          "AFTER".split("").join("\n"),
                                          style: getTextStyle(
                                              textColor: AppColors.grey,
                                              fontFamily: AppFonts.montserrat,
                                              fontWeight:
                                                  AppFontWeights.regular,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 21),
                                        child: Image.network(
                                          completedRequest['completionProof'] ??
                                              '',
                                          width: 107,
                                          height: 107,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget totalSection() => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          height: 217,
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
                    left: 14, right: 14, top: 11, bottom: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        const Spacer(),
                        Text(
                          completedRequest['suggestedFee'] ?? '',
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
                            serviceFee.toString(),
                            style: getTextStyle(
                                textColor: AppColors.black,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 11),
                          ),
                          const Spacer(),
                          Text(
                            convenienceFee.toString(),
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
                padding: EdgeInsets.only(left: 15, top: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWithIcon(
                      icon: Icon(Icons.place,
                          size: 17, color: AppColors.accentOrange),
                      text: completedRequest['address'] ?? '',
                      fontSize: 12,
                      contentPadding: 19,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TextWithIcon(
                        icon: Icon(Icons.calendar_month_rounded,
                            size: 17, color: AppColors.accentOrange),
                        text: completedRequest['date'] ?? '',
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TextWithIcon(
                        icon: Icon(Icons.watch_later,
                            size: 17, color: AppColors.accentOrange),
                        text: completedRequest['time'] ?? '',
                        fontSize: 12,
                        contentPadding: 19,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TextWithIcon(
                        icon: Icon(Icons.local_offer_rounded,
                            size: 17, color: AppColors.accentOrange),
                        text: completedRequest['suggestedFee'] ?? '',
                        fontSize: 12,
                        contentPadding: 19,
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
