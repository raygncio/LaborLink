import 'package:flutter/material.dart';
import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/Pages/Registration/SignupPage.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/styles.dart';

import '../Widgets/Buttons/FilledButton.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
              padding: const EdgeInsets.only(top: 67, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/LOGO 1.png"),
                  Padding(
                      padding: const EdgeInsets.only(top: 56),
                      child: Image.asset(
                        "assets/icons/main_img.png",
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 106),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            AppFilledButton(
                                fontFamily: AppFonts.poppins,
                                fontSize: 18,
                                height: 42,
                                text: "CREATE AN ACCOUNT",
                                color: AppColors.accentOrange,
                                command: onCreateAccount,
                                borderRadius: 5),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: AppColors.grey,
                                  thickness: 1,
                                  height: 0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  "or",
                                  style: getTextStyle(
                                      textColor: AppColors.grey,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: AppFontWeights.bold,
                                      fontSize: 14),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: AppColors.grey,
                                  thickness: 1,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              AppOutlinedButton(
                                  text: "LOG - IN",
                                  color: AppColors.accentOrange,
                                  command: onLogin,
                                  borderRadius: 5),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void onCreateAccount() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupPage(),
    ));
  }

  void onLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ));
  }
}
