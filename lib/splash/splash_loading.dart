import 'package:flutter/material.dart';
import 'package:laborlink/ai/style.dart';

class SplashLoadingPage extends StatelessWidget {
  const SplashLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
