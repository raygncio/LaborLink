import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class ClientRequestSuccessPage extends StatefulWidget {
  const ClientRequestSuccessPage({Key? key}) : super(key: key);

  @override
  State<ClientRequestSuccessPage> createState() =>
      _ClientRequestSuccessPageState();
}

class _ClientRequestSuccessPageState extends State<ClientRequestSuccessPage> {
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
                    "Request Successful",
                    style: getTextStyle(
                        textColor: AppColors.secondaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "We’ll let you know when a handyman\nis available",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                        textColor: AppColors.black,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.regular,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 147,
                  child: Row(
                    children: [
                      AppFilledButton(
                          height: 35,
                          padding: const EdgeInsets.only(top: 60),
                          text: "Check Activity",
                          fontSize: 15,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.secondaryBlue,
                          command: onCheckActivity,
                          borderRadius: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: onGoHome,
                    child: Text("Go Home",
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCheckActivity() => Navigator.of(context).pop("activity");

  void onGoHome() => Navigator.of(context).pop("home");
}
