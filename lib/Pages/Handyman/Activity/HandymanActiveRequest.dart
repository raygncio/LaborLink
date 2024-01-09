import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/RequestCompleteSuccessPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/MessageButton.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Buttons/ReportIssueButton.dart';
import 'package:laborlink/Widgets/Cards/ClientInfoCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/ProgressIndicator.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class HandymanActiveRequest extends StatefulWidget {
  final Map<String, dynamic> requestDetail;
  final Map<String, dynamic> clientDetail;
  const HandymanActiveRequest(
      {Key? key, required this.requestDetail, required this.clientDetail})
      : super(key: key);

  @override
  State<HandymanActiveRequest> createState() => _HandymanActiveRequestState();
}

class _HandymanActiveRequestState extends State<HandymanActiveRequest> {
  late int _currentProgress;
  bool _requestCompleted = false;
  // Map<String, dynamic> getActiveRequest = {};
  DatabaseService service = DatabaseService();

  List<String> progressDescriptions = [
    "Click the button below if you're on your way!",
    "You are on your way to the client's location!",
    "You have arrived at the location!",
    "Your service is now in progress!",
    "Service complete! Waiting for client to confirm.",
    "Service complete on both parties!"
  ];

  List<String> buttonTexts = [
    "I'm on my way!",
    "I have arrived!",
    "Service in action",
    "Service complete!",
    "Rate Client",
  ];

  @override
  void initState() {
    print("new test");
    print(widget.requestDetail['progress']);
    if (widget.requestDetail["progress"] == 'rating') {
      _currentProgress = 5;
    } else if (widget.requestDetail["progress"] == 'omw') {
      _currentProgress = 1;
    } else if (widget.requestDetail["progress"] == 'arrived') {
      _currentProgress = 2;
    } else if (widget.requestDetail["progress"] == 'inprogress') {
      _currentProgress = 3;
    } else if (widget.requestDetail["progress"] == 'completion') {
      _currentProgress = 4;
    } else {
      _currentProgress = 0;
    }
    _requestCompleted = _currentProgress == 5;
    super.initState();
    // Future.delayed(Duration(seconds: 1), () {
    //   getClientInfo();
    // });
  }

  // void getClientInfo() async {
  //   print(widget.requestDetail['userId']);
  //   try {
  //     getActiveRequest =
  //         await service.getActiveRequestClient(widget.requestDetail["userId"]);
  //     print(getActiveRequest);
  //   } catch (error) {
  //     print('Error fetching user data: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            color: AppColors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 96, left: 25, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 8),
                              width: 200,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.requestDetail["title"] ?? '',
                                  style: getTextStyle(
                                      textColor: AppColors.tertiaryBlue,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                            AppBadge(
                                label: _requestCompleted
                                    ? "Completed"
                                    : "In Progress",
                                type: _requestCompleted
                                    ? BadgeType.complete
                                    : BadgeType.inProgress,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2)),
                          ],
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            widget.requestDetail["requestId"] ?? '',
                            style: getTextStyle(
                                textColor: AppColors.tertiaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Text(
                            widget.requestDetail["description"] ?? '',
                            overflow: TextOverflow.visible,
                            style: getTextStyle(
                                textColor: AppColors.black,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 12),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: TextWithIcon(
                                icon: Icon(Icons.place,
                                    size: 17, color: AppColors.accentOrange),
                                text: widget.requestDetail["address"] ?? '',
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextWithIcon(
                                icon: Icon(Icons.calendar_month_rounded,
                                    size: 17, color: AppColors.accentOrange),
                                text: widget.requestDetail["date"] ?? '',
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextWithIcon(
                                icon: Icon(Icons.watch_later,
                                    size: 17, color: AppColors.accentOrange),
                                text: widget.requestDetail["time"] ?? '',
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextWithIcon(
                                icon: Icon(Icons.local_offer_rounded,
                                    size: 17, color: AppColors.accentOrange),
                                text: widget.requestDetail["suggestedPrice"]
                                        .toString() ??
                                    '',
                                fontSize: 12,
                                contentPadding: 19,
                              ),
                            ),
                            AppProgressIndicator(
                                padding: const EdgeInsets.only(top: 39),
                                descriptionPadding:
                                    const EdgeInsets.only(top: 11),
                                description:
                                    progressDescriptions[_currentProgress],
                                max: 4,
                                currentProgress: _currentProgress),
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: SizedBox(
                                width: 171,
                                child: Row(
                                  children: [
                                    AppFilledButton(
                                        enabled: _currentProgress != 4,
                                        height: 29,
                                        text: buttonTexts[_currentProgress > 4
                                            ? _currentProgress - 1
                                            : _currentProgress],
                                        fontSize: 15,
                                        fontFamily: AppFonts.montserrat,
                                        color: AppColors.secondaryBlue,
                                        command: updateProgress,
                                        borderRadius: 8)
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: ReportIssueButton(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Stack(children: [
                  Visibility(
                    visible: _currentProgress >= 0,
                    child: FutureBuilder(
                      future: Future.delayed(Duration(seconds: -1)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClientInfoCard(
                              clientInfo: widget.clientDetail);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  Positioned(
                      top: 13,
                      right: 22,
                      child: MessageButton(command: onMessageButtonClick))
                ]),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onMessageButtonClick() {
    sendMessage(
      '0123456789',
      'Hello, this is a test message!', // Your desired message content
    );
  }

  Future<void> sendMessage(String phoneNumber, String message) async {
    final Uri url = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('Could not launch SMS');
        // Handle error if unable to launch the SMS app
      }
    } catch (e) {
      print('Error launching SMS: $e');
      // Handle error
    }
  }

  void updateProgress() async {
    if (!_requestCompleted) {
      setState(() {
        _currentProgress += 1;
        _requestCompleted = _currentProgress == 5;
      });

      // Update the progress in the database
      await service.updateRequestProgressHandyman(
        widget.requestDetail["requestId"],
        _currentProgress,
      );
    } else {
      attachServiceProofDialog(context, widget.clientDetail);
    }
  }
}
