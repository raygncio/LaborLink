import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class OfferSubmittedPage extends StatefulWidget {
  const OfferSubmittedPage({Key? key}) : super(key: key);

  @override
  State<OfferSubmittedPage> createState() => _OfferSubmittedPageState();
}

class _OfferSubmittedPageState extends State<OfferSubmittedPage> {
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
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    "Offer Submitted!",
                    style: getTextStyle(
                        textColor: AppColors.secondaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 25),
                  ),
                ),
                Text(
                  "We’ll let you know once the client has\naccepted your bid!",
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 12),
                ),
                SizedBox(
                  width: 147,
                  child: Row(
                    children: [
                      AppFilledButton(
                          height: 35,
                          padding: const EdgeInsets.only(top: 28),
                          text: "Go to Services",
                          fontSize: 15,
                          fontFamily: AppFonts.montserrat,
                          color: AppColors.secondaryBlue,
                          command: onGoToServices,
                          borderRadius: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: GestureDetector(
                    onTap: onContinue,
                    child: Text("Continue",
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

  void onGoToServices() => Navigator.of(context).pop("services");

  void onContinue() => Navigator.of(context).pop("continue");
}
