import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Checkbox.dart';
import 'package:laborlink/styles.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  final dummyText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo";

  bool agreeWithTermsAndCondition = false;
  bool agreeWithPrivacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: deviceWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/LOGO 1.png",
                  height: 48,
                  width: 157,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Text(
                    "TERMS & CONDITIONS",
                    overflow: TextOverflow.visible,
                    style: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Text(
                              "${dummyText}\n${dummyText}\n${dummyText}\n${dummyText}\n${dummyText}\n${dummyText}\n",
                              overflow: TextOverflow.visible,
                              style: getTextStyle(
                                  textColor: AppColors.tertiaryBlue,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: AppFontWeights.medium,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 46),
                  child: AppCheckBox(
                    label: "I AGREE WITH THE TERMS AND CONDITIONS",
                    labelStyle: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.poppins,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 7),
                    checkboxColor: AppColors.grey,
                    borderRadius: 3,

                    borderWidth: 2,
                    onChanged: (value) {
                      setState(() {
                        agreeWithTermsAndCondition = value;
                      });
                    },
                  ),
                ),
                AppCheckBox(
                    label: "I AGREE WITH THE PRIVACY POLICY",
                    labelStyle: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.poppins,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 7),
                    checkboxColor: AppColors.grey,
                    borderRadius: 3,
                    borderWidth: 2,
                    onChanged: (value) {
                      setState(() {
                        agreeWithPrivacyPolicy = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      AppOutlinedButton(
                          padding: const EdgeInsets.only(right: 10),
                          text: "CANCEL",
                          color: AppColors.tertiaryBlue,
                          command: onCancel,
                          borderRadius: 8),
                      AppFilledButton(
                          padding: const EdgeInsets.only(left: 10),
                          enabled: agreeWithTermsAndCondition &&
                              agreeWithPrivacyPolicy,
                          fontFamily: AppFonts.poppins,
                          fontSize: 15,
                          height: 42,
                          text: "REGISTER",
                          color: AppColors.tertiaryBlue,
                          command: onRegister,
                          borderRadius: 8)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCancel() {}

  void onRegister() {}
}
