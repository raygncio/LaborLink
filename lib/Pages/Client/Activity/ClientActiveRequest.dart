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
import 'package:laborlink/styles.dart';

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

  @override
  Widget build(BuildContext context) {
    _currentProgress = widget.requestDetail["progress"];
    _requestCompleted = _currentProgress == 4;

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
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    widget.requestDetail["title"],
                                    style: getTextStyle(
                                        textColor: AppColors.tertiaryBlue,
                                        fontFamily: AppFonts.montserrat,
                                        fontWeight: AppFontWeights.bold,
                                        fontSize: 17),
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
                            Text(
                              "Request ID",
                              style: getTextStyle(
                                  textColor: AppColors.tertiaryBlue,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: AppFontWeights.regular,
                                  fontSize: 13),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 27),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.place,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["address"],
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
                                    text: widget.requestDetail["date"],
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
                                    text: widget.requestDetail["time"],
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: TextWithIcon(
                                    icon: Icon(Icons.local_offer_rounded,
                                        size: 17,
                                        color: AppColors.accentOrange),
                                    text: widget.requestDetail["suggestedFee"],
                                    fontSize: 12,
                                    contentPadding: 19,
                                  ),
                                ),
                                AppProgressIndicator(
                                    padding: const EdgeInsets.only(top: 51),
                                    description: "Handyman has arrived!",
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
                HandymanInfoCard(handymanInfo: dummyFilteredHandyman[0]),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onMessageButtonClick() {}

  void onConfirm() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const RequestCompleteSuccessPage(),
    ));
  }
}
