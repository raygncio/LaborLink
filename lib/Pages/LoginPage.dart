import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Forms/LoginForm.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'package:laborlink/styles.dart';
import '../Widgets/Buttons/FilledButton.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
                    ),
                  ),
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
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 14),
                        //   child: Flex(
                        //     direction: Axis.horizontal,
                        //     children: [
                        //       AppOutlinedButton(
                        //           text: "BACK",
                        //           color: AppColors.accentOrange,
                        //           command: onBack,
                        //           borderRadius: 5),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void onLogin() async {
    if (loginFormKey.currentState!.validateForm()) {
      Map<String, dynamic> logInfo = loginFormKey.currentState!.getFormData;
      DatabaseService service = DatabaseService();

      final enteredEmail = logInfo["username"]?.toString().trim() ?? "";
      final enteredPassword = logInfo["password"]?.toString().trim() ?? "";

      // Check if entered input is an email format
      bool isEmail = enteredEmail.contains('@');

      try {
        late UserCredential userCredential;

        if (isEmail) {
          // Sign in using email and password directly
          userCredential = await _firebase.signInWithEmailAndPassword(
            email: enteredEmail,
            password: enteredPassword,
          );
        } else {
          // If the input is a username, search for the associated email
          String? emailFromUsername =
              await service.getEmailFromUsername(enteredEmail);

          if (emailFromUsername != null) {
            // Sign in using the retrieved email and password
            userCredential = await _firebase.signInWithEmailAndPassword(
              email: emailFromUsername,
              password: enteredPassword,
            );
          }
        }

        // pop out of login page
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        // Handle login errors, e.g., show an error message.
        print("Login error: $e");
        displaySnackbar(e);
      }
    } else {
      // Show an error message for not entering valid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid credentials."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void displaySnackbar(FirebaseAuthException e) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? 'Authentication Failed'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void onBack() {
    Navigator.of(context).pop();
  }
}
