import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Report/ReportIssuePage.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/styles.dart';

class ReportIssueButton extends StatefulWidget {
  const ReportIssueButton({Key? key}) : super(key: key);

  @override
  State<ReportIssueButton> createState() => _ReportIssueButtonState();
}

class _ReportIssueButtonState extends State<ReportIssueButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 171,
      child: Row(
        children: [
          AppOutlinedButton(
            height: 29,
            textStyle: getTextStyle(
                textColor: AppColors.pink,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.bold,
                fontSize: 12),
            text: "Report an Issue",
            color: AppColors.pink,
            prefixIcon: const Icon(
              Icons.flag,
              color: AppColors.pink,
              size: 10,
            ),
            command: onReportIssue,
            borderRadius: 8,
            borderWidth: 1,
          ),
        ],
      ),
    );
  }

  void onReportIssue() => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReportIssuePage(),
      ));
}
