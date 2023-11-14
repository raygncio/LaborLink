import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class VerificationLoadingPage extends StatefulWidget {
  const VerificationLoadingPage({Key? key}) : super(key: key);

  @override
  State<VerificationLoadingPage> createState() =>
      _VerificationLoadingPageState();
}

class _VerificationLoadingPageState extends State<VerificationLoadingPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 221),
        child: Center(
          child: Column(children: [
            RotationTransition(
              turns: animation,
              child: Transform.rotate(
                angle: 1,
                child: Image.asset(
                  "assets/icons/loading.png",
                  height: 112,
                  width: 112,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Text(
                "Hang on",
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 43),
              child: Text(
                "We’re verifying your credentials",
                textAlign: TextAlign.center,
                style: getTextStyle(
                    textColor: AppColors.black,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void onGotIt() {}
}
