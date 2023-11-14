import 'package:flutter/material.dart';
import 'package:laborlink/Pages/RatingsPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class RequestCompleteSuccessPage extends StatefulWidget {
  const RequestCompleteSuccessPage({Key? key}) : super(key: key);

  @override
  State<RequestCompleteSuccessPage> createState() =>
      _RequestCompleteSuccessPageState();
}

class _RequestCompleteSuccessPageState
    extends State<RequestCompleteSuccessPage> {
  int successPagePhase = 1;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          color: AppColors.white,
          child: Column(
            children: [
              Padding(
                padding: successPagePhase == 1
                    ? const EdgeInsets.only(left: 57, right: 57, top: 143)
                    : const EdgeInsets.only(left: 27, right: 28, top: 123),
                child: Image.asset(
                    "assets/icons/${successPagePhase == 1 ? "payment-icon" : "success"}.png"),
              ),
              Padding(
                padding: EdgeInsets.only(top: successPagePhase == 1 ? 29 : 32),
                child: Text(
                  successPagePhase == 1
                      ? "Pay upon Completion"
                      : "Request Complete!",
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 61),
                child: Text(
                  successPagePhase == 1
                      ? "Please prepare to give the discussed  amount to the handyman. Thank you!"
                      : "We keep your completed requestsin the activity history",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 12),
                ),
              ),
              Visibility(
                visible: successPagePhase == 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: Text(
                    "₱550",
                    style: getTextStyle(
                        textColor: AppColors.accentOrange,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                width: 147,
                child: Row(
                  children: [
                    AppFilledButton(
                        padding: EdgeInsets.only(
                            top: successPagePhase == 1 ? 23 : 59),
                        height: 35,
                        text: "Continue",
                        fontSize: 15,
                        fontFamily: AppFonts.montserrat,
                        color: AppColors.secondaryBlue,
                        command: onContinue,
                        borderRadius: 8),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onContinue() {
    if (successPagePhase == 1) {
      setState(() {
        successPagePhase += 1;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const RatingsPage(),
      ));
    }
  }
}
