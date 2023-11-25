import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Report/IssuesReportedPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class ReportSubmittedPage extends StatefulWidget {
  final String userId;
  const ReportSubmittedPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReportSubmittedPage> createState() => _ReportSubmittedPageState();
}

class _ReportSubmittedPageState extends State<ReportSubmittedPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 123),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/success.png",
                  height: 263,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 33),
                  child: Text(
                    "Report Submitted!",
                    style: getTextStyle(
                        textColor: AppColors.secondaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 61, right: 61, top: 12),
                  child: Text(
                    "Thank you for your bringing this to our attention. We’ll do our best to handle this issue as soon as possible!",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: getTextStyle(
                        textColor: AppColors.black,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.medium,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 147,
                  child: Row(
                    children: [
                      AppFilledButton(
                          height: 35,
                          padding: const EdgeInsets.only(top: 42),
                          text: "Check Reports",
                          fontSize: 15,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.secondaryBlue,
                          command: onCheckReports,
                          borderRadius: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: GestureDetector(
                    onTap: onContinue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        width: 147,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Continue",
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              textColor: AppColors.white,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCheckReports() =>
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => IssuesReportedPage(userId: widget.userId),
      ));

  void onContinue() => Navigator.of(context).pop();
}
