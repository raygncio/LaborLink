import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Forms/LoginForm.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';

import '../Widgets/Buttons/FilledButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<LoginFormState> loginFormKey = GlobalKey<LoginFormState>();

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
              padding: const EdgeInsets.only(top: 55, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/LOGO 1.png"),
                  Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Image.asset(
                        "assets/icons/login_img.png",
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 21),
                    child: LoginForm(key: loginFormKey),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 33),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            AppFilledButton(
                                fontFamily: AppFonts.poppins,
                                fontSize: 18,
                                height: 42,
                                text: "LOG - IN",
                                color: AppColors.accentOrange,
                                command: onLogin,
                                borderRadius: 5),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              AppOutlinedButton(
                                  text: "BACK",
                                  color: AppColors.accentOrange,
                                  command: onBack,
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

  void onLogin() {
    print("LOGIN");
  }

  void onBack() {
    Navigator.of(context).pop();
  }
}
