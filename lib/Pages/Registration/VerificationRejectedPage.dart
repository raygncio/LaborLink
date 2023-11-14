import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class VerificationRejectedPage extends StatefulWidget {
  const VerificationRejectedPage({Key? key}) : super(key: key);

  @override
  State<VerificationRejectedPage> createState() =>
      _VerificationRejectedPageState();
}

class _VerificationRejectedPageState extends State<VerificationRejectedPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 221),
        child: Center(
          child: Column(children: [
            Image.asset(
              "assets/icons/DECLINE.png",
              height: 112,
              width: 112,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Text(
                "Credentials Approved",
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "We’ve detected something unusual in\nthe credentials you’ve passed. \n\nPlease try again if you think this is a\nmistake or contact us.",
                textAlign: TextAlign.center,
                style: getTextStyle(
                    textColor: AppColors.black,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 106, right: 106, top: 42),
              child: Row(
                children: [
                  AppFilledButton(
                      fontFamily: AppFonts.montserrat,
                      fontSize: 15,
                      height: 35,
                      text: "Got it!",
                      color: AppColors.secondaryBlue,
                      command: onGotIt,
                      borderRadius: 8),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  void onGotIt() {}
}
