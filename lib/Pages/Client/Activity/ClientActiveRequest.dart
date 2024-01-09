import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/RequestCompleteSuccessPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/MessageButton.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Buttons/ReportIssueButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/ProgressIndicator.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/styles.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late String _progress;
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
  Widget build(BuildContext context) {
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
    print('Request Detail: ${widget.requestDetail}');

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
                                  padding: EdgeInsets.only(top: 27),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.place,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["address"] ?? '',
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.calendar_month_rounded,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["date"] ?? '',
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.watch_later,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["time"] ?? '',
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: TextWithIcon(
                                      icon: Icon(Icons.local_offer_rounded,
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
                                  padding: EdgeInsets.only(
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
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: ReportIssueButton(),
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
