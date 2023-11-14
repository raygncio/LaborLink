import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Transform.translate(
            offset: const Offset(-10, 0),
            child: Image.asset("assets/icons/logo.png")),
      ),
    );
  }
}
