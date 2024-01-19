import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/RequestCompleteSuccessPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/MessageButton.dart';
import 'package:laborlink/Widgets/Buttons/ReportIssueButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/ProgressIndicator.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ClientActiveRequest extends StatefulWidget {
  final Map<String, dynamic> requestDetail;
  const ClientActiveRequest({Key? key, required this.requestDetail})
      : super(key: key);

  @override
  State<ClientActiveRequest> createState() => _ClientActiveRequestState();
}

class _ClientActiveRequestState extends State<ClientActiveRequest> {
  late int _currentProgress;
  late bool _requestCompleted;
  late String _progress = ' ';
  Request? requestInfo;
  Timer? timer;
  DatabaseService service = DatabaseService();
  List<String> progressDescriptions = [
    "Waiting for the handyman",
    "Handyman is on the way to your location!",
    "Handyman has arrived!",
    "Your service is now in progress!",
    "Service complete!",
    "Service complete on both parties!"
  ];
  @override
  void initState() {
    super.initState();

    if (widget.requestDetail["progress"] == 'completion') {
      _currentProgress = 4;
      _progress = 'Completion';
    } else if (widget.requestDetail["progress"] == 'omw') {
      _currentProgress = 1;
      _progress = 'On the way';
    } else if (widget.requestDetail["progress"] == 'arrived') {
      _currentProgress = 2;
      _progress = 'Arrived';
    } else if (widget.requestDetail["progress"] == 'inprogress') {
      _currentProgress = 3;
      _progress = 'In Progress';
    } else {
      _currentProgress = 0;
    }
    _requestCompleted = _currentProgress == 4;

    if (widget.requestDetail["progress"] != 'completion') {
      //check email verification status every 3 sec
      timer = Timer.periodic(
        const Duration(seconds: 4),
        (timer) => reloadPage(),
      );
    } else if (widget.requestDetail["progress"] == 'completion') {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  void reloadPage() async {
    int currentProgress = 0;
    String status = ' ';
    // Use setState to trigger a rebuild of the widget
    try {
      requestInfo =
          await service.getRequestsData(widget.requestDetail["clientId"]);

      print('progress: ${requestInfo!.progress}');

      if (requestInfo!.progress == 'completion') {
        currentProgress = 4;
        status = 'Completion';
      } else if (requestInfo!.progress == 'omw') {
        currentProgress = 1;
        status = 'On the way';
      } else if (requestInfo!.progress == 'arrived') {
        currentProgress = 2;
        status = 'Arrived';
      } else if (requestInfo!.progress == 'inprogress') {
        currentProgress = 3;
        status = 'In Progress';
      } else if (requestInfo!.progress == 'hired') {
        currentProgress = 0;
        status = 'Hired';
      }

      setState(() {
        _currentProgress = currentProgress;
        _progress = status;
        _requestCompleted = currentProgress == 4;
      });
    } catch (error) {
      print('Error fetching get user data: $error');
    }
  }

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
                        const EdgeInsets.only(top: 106, left: 25, right: 24),
                    child: Stack(
                      children: [
                        Column(
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
                                      softWrap: false,
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
                                        : _progress,
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
                                "Request ID: " +
                                        widget.requestDetail["requestId"] ??
                                    '',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: getTextStyle(
                                    textColor: AppColors.tertiaryBlue,
                                    fontFamily: AppFonts.montserrat,
                                    fontWeight: AppFontWeights.regular,
                                    fontSize: 13),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 27),
                                  child: TextWithIcon(
                                    icon: const Icon(Icons.place,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["address"] ?? '',
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: TextWithIcon(
                                    icon: const Icon(
                                        Icons.calendar_month_rounded,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["date"] ?? '',
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: TextWithIcon(
                                    icon: const Icon(Icons.watch_later,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["time"] ?? '',
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: TextWithIcon(
                                      icon: const Icon(
                                          Icons.local_offer_rounded,
                                          size: 17,
                                          color: AppColors.accentOrange),
                                      text: widget
                                          .requestDetail["suggestedPrice"]
                                          .toString(),
                                      fontSize: 12,
                                      contentPadding: 19,
                                    ),
                                  ),
                                ),
                                // Update the padding for the description text
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15,
                                      left: 10,
                                      right:
                                          10), // Adjust left padding as needed
                                  child: Text(
                                    widget.requestDetail["requestDesc"] ?? '',
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow
                                        .ellipsis, // You can adjust overflow property based on your requirement
                                    maxLines:
                                        3, // You can adjust maxLines based on your requirement
                                    style: getTextStyle(
                                      textColor: AppColors.black,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.regular,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                AppProgressIndicator(
                                    padding: const EdgeInsets.only(top: 51),
                                    description:
                                        progressDescriptions[_currentProgress],
                                    max: 4,
                                    currentProgress: _currentProgress),
                              ],
                            )
                          ],
                        ),
                        Positioned(
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: _requestCompleted,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: SizedBox(
                                    width: 85,
                                    child: Row(
                                      children: [
                                        AppFilledButton(
                                          height: 21,
                                          text: "Confirm",
                                          color: AppColors.secondaryBlue,
                                          command: onConfirm,
                                          borderRadius: 8,
                                          fontSize: 9,
                                          fontFamily: AppFonts.montserrat,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              MessageButton(command: onMessageButtonClick)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ReportIssueButton(
                        userId: widget.requestDetail["clientId"]),
                  ),
                ),
                HandymanInfoCard(handymanInfo: widget.requestDetail),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onMessageButtonClick() {
    sendMessage(
      '09171792602',
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

  void onConfirm() async {
    try {
      await service.updateRequest(widget.requestDetail["clientId"]);
    } catch (error) {
      print('Error fetching user data: $error');
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          RequestCompleteSuccessPage(details: widget.requestDetail),
    ));
  }
}
