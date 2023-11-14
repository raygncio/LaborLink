import 'package:flutter/material.dart';
import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/Pages/Registration/HandymanRegistrationPage.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/users.dart';

import '../../Widgets/Buttons/CardButton.dart';
import '../../Widgets/Buttons/FilledButton.dart';
import '../../Widgets/Buttons/OutlinedButton.dart';
import 'ClientRegistrationPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  AppUserType? selectedUserType;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: deviceWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 67),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/icons/LOGO 1.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 42),
                  child: Text(
                    "Join as a client or a\nhandyman!",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.poppins,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 18),
                  ),
                ),
                userTypeSelection(),
                Padding(
                  padding: const EdgeInsets.only(left: 61, right: 61, top: 58),
                  child: Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          AppFilledButton(
                              enabled: selectedUserType != null,
                              fontFamily: AppFonts.poppins,
                              fontSize: 18,
                              height: 42,
                              text: "SIGN UP",
                              color: AppColors.tertiaryBlue,
                              borderRadius: 5,
                              command: onSignup),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 17),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            AppOutlinedButton(
                                text: "BACK",
                                color: AppColors.tertiaryBlue,
                                borderRadius: 5,
                                command: onBack),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: getTextStyle(
                            textColor: AppColors.tertiaryBlue,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.medium,
                            fontSize: 10),
                      ),
                      GestureDetector(
                        onTap: onLogin,
                        child: Text(
                          "Log-in",
                          style: getTextStyle(
                              textColor: AppColors.tertiaryBlue,
                              fontFamily: AppFonts.poppins,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 10),
                        ),
                      )
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

  Widget userTypeSelection() => Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardButtonWidget(
                imgPath: "assets/icons/customer.png",
                description: "I’m a client looking for a handyman",
                isSelected: selectedUserType == AppUserType.client,
                command: () => selectUserType(AppUserType.client)),
            CardButtonWidget(
                imgPath: "assets/icons/laborer.png",
                description: "I’m a handyman looking for a repair task",
                isSelected: selectedUserType == AppUserType.handyman,
                command: () => selectUserType(AppUserType.handyman))
          ],
        ),
      );

  void onSignup() {
    print("SIGN UP");

    if (selectedUserType == AppUserType.client) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ClientRegistrationPage(),
      ));
    } else if (selectedUserType == AppUserType.handyman) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HandymanRegistrationPage(),
      ));
    }
  }

  void onLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ));
  }

  void onBack() {
    Navigator.of(context).pop();
  }

  void selectUserType(AppUserType selectedUserType) {
    setState(() {
      this.selectedUserType = selectedUserType;
    });
  }
}
