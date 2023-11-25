import 'package:flutter/material.dart';
import 'package:laborlink/ai/style.dart';
import 'package:lottie/lottie.dart';

class SplashId extends StatelessWidget {
  const SplashId({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Lottie.asset(
              'assets/animations/id-verification.json',
            ),
          ),
          Text(
            'We need to verify it\'s you',
            textAlign: TextAlign.center,
            style: getTextStyle(
                textColor: AppColors.primaryBlue,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.bold,
                fontSize: 25),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Note: Please stay still before capturing :)',
            textAlign: TextAlign.center,
            style: getTextStyle(
                textColor: AppColors.primaryBlue,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.medium,
                fontSize: 15),
          ),
        ],
      ),
    );
  }
}
