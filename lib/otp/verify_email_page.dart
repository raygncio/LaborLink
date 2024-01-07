import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() {
    return _VerifyEmailPageState();
  }
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // check registered user if email is verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      //check email verification status every 3 sec
      timer = Timer.periodic(
        Duration(seconds: 3),
        (timer) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // dispose timer when not used
    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification
    // need to reload user every time before calling .emailVerified
    await FirebaseAuth.instance.currentUser!.reload();

    // update UI upon checking
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  showErrorMessages(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.red,
      ),
    );
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      showErrorMessages(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      ref.read(currentUserProvider.notifier).saveCurrentUserInfo();

      Map<String, dynamic> userInfo = ref.watch(currentUserProvider);
      String? userId = userInfo['userId'];
      String? userRole = userInfo['userRole'];

      print('>>>>>>>>>>> userId: $userId');
      print('>>>>>>>>>>> userrole: $userRole');

      if (userRole == 'client') {
        return ClientMainPage(userId: userId ?? '');
      } else if (userRole == 'handyman') {
        return HandymanMainPage(userId: userId!);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animations/handyman.json'),
              const SizedBox(
                height: 12,
              ),
              Text(
                'A verification email has been sent to your email.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue),
                icon: const Icon(
                  Icons.email,
                  size: 32,
                ),
                label: Text(
                  'Resend Email',
                  style: getTextStyle(
                      textColor: AppColors.white,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.medium,
                      fontSize: 15),
                ),
                onPressed: canResendEmail ? sendVerificationEmail : null,
              ),
              const SizedBox(
                height: 12,
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                child: Text(
                  'Cancel',
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 15),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
