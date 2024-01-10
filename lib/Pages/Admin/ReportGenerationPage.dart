import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

enum ReportType { faceVerification, anomalyDetection }

class ReportGenerationPage extends StatefulWidget {
  final reportType;
  const ReportGenerationPage({Key? key, required this.reportType})
      : super(key: key);

  @override
  State<ReportGenerationPage> createState() => _ReportGenerationPageState();
}

class _ReportGenerationPageState extends State<ReportGenerationPage> {
  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            appBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 15, top: 22),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.secondaryBlue,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Text(
                          "${widget.reportType == ReportType.faceVerification ? "Face Verification" : "Anomaly Detection"} Report",
                          style: getTextStyle(
                              textColor: AppColors.white,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 20),
                        ),
                      ),
                      const Icon(
                        Icons.description,
                        color: AppColors.white,
                        size: 25,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                AppFilledButton(
                    padding: const EdgeInsets.only(
                        left: 25, right: 23, bottom: 21, top: 28),
                    height: 42,
                    text: "Download PDF",
                    fontSize: 18,
                    fontFamily: AppFonts.poppins,
                    color: AppColors.accentOrange,
                    command: () {},
                    borderRadius: 5),
              ],
            )
          ],
        ),
      )),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Container(
        color: AppColors.secondaryBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 14),
                child: GestureDetector(
                  onTap: onBack,
                  child: Image.asset(
                    "assets/icons/back-btn-2.png",
                    width: 10,
                    height: 18,
                  ),
                ),
              ),
              Text(
                "Reports Generation",
                style: getTextStyle(
                    textColor: AppColors.secondaryYellow,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 20),
              )
            ],
          ),
        ),
      );
}
