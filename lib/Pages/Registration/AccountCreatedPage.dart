import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/Pages/LandingPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/ai/screens/splash_success.dart';
import 'package:laborlink/styles.dart';

class AccountCreatedPage extends StatefulWidget {
  const AccountCreatedPage({Key? key}) : super(key: key);

  @override
  State<AccountCreatedPage> createState() => _AccountCreatedPageState();
}

class _AccountCreatedPageState extends State<AccountCreatedPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const SplashSuccessPage();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Image.asset(
            "assets/icons/reg_bg.png",
            width: deviceWidth,
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 221),
            child: Center(
              child: Column(children: [
                Image.asset(
                  "assets/icons/APPROVE.png",
                  height: 112,
                  width: 112,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: Text(
                    "CONGRATULATIONS!",
                    style: getTextStyle(
                        textColor: AppColors.white,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "You have successfully\ncreated an account!",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                        textColor: AppColors.white,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.normal,
                        fontSize: 13),
                  ),
                ),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 71, right: 71, bottom: 50),
              child: SizedBox(
                width: deviceWidth,
                child: Row(
                  children: [
                    AppFilledButton(
                        fontFamily: AppFonts.poppins,
                        fontSize: 18,
                        height: 42,
                        text: "GET STARTED",
                        color: AppColors.accentOrange,
                        command: onGetStarted,
                        borderRadius: 8),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onGetStarted() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const LandingPage(),
        ),
      );
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (ctx) => const LandingPage(),
      //     ),
      //     (route) => false);
    });
  }
}
