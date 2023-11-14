import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class HandymanForApprovalPage extends StatefulWidget {
  const HandymanForApprovalPage({Key? key}) : super(key: key);

  @override
  State<HandymanForApprovalPage> createState() =>
      _HandymanForApprovalPageState();
}

class _HandymanForApprovalPageState extends State<HandymanForApprovalPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 166),
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Image.asset(
                "assets/icons/success.png",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Text(
                "Almost there!",
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Text(
                "Please excuse us for a moment while\nwe review your application. We’ll email\nyou when you’re ready to go!",
                textAlign: TextAlign.center,
                style: getTextStyle(
                    textColor: AppColors.black,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.normal,
                    fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 106, right: 106, top: 33),
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
