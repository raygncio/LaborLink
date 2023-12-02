import 'package:flutter/material.dart';
import 'package:laborlink/ai/style.dart';
import 'package:lottie/lottie.dart';

class SplashHandymanPage extends StatelessWidget {
  const SplashHandymanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Lottie.asset('assets/animations/handyman.json'),
      ),
    );
  }
}
