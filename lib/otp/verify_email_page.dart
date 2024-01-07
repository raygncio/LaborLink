import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage(
      {super.key, required this.userId, required this.userRole});

  final String userId;
  final String userRole;

  @override
  ConsumerState<VerifyEmailPage> createState() {
    return _VerifyEmailPageState();
  }
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool isSameUserId = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // check registered user if email is verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    isSameUserId = checkUserId();

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

  checkUserId() {
    if (widget.userId == FirebaseAuth.instance.currentUser!.uid) {
      return true;
    }
    return false;
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
    if (isEmailVerified && isSameUserId) {
      if (widget.userRole == 'client') {
        return ClientMainPage(userId: widget.userId ?? '');
      } else if (widget.userRole == 'handyman') {
        return HandymanMainPage(userId: widget.userId!);
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
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'A verification email has been sent to your email.',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
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
