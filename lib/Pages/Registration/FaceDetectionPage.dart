import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/styles.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  bool isProcessing = true;
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 68),
                child: Image.asset(
                  "assets/icons/LOGO 1.png",
                  height: 48,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "FACE VERIFICATION",
                  style: getTextStyle(
                      textColor: AppColors.tertiaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 29, right: 30, top: 44),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.greyD9,
                                border: Border.all(
                                    color: isComplete
                                        ? AppColors.green
                                        : AppColors.grey,
                                    width: 3)),
                          ),
                          Visibility(
                            visible: isComplete,
                            child: Align(
                              alignment: const FractionalOffset(0.9, 0.1),
                              child: Image.asset(
                                "assets/icons/APPROVE.png",
                                width: constraints.maxWidth * 0.15,
                                height: constraints.maxWidth * 0.15,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 37, right: 38, top: 54),
                child: Text(
                  isProcessing
                      ? "Position your face inside the circle, and wait for the verification"
                      : isComplete
                          ? "Verification complete!"
                          : "Verification failed.\nPlease try again.",
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.tertiaryBlue,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 14),
                ),
              ),
              Visibility(
                visible: !isProcessing,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 177,
                        child: Row(
                          children: [
                            AppFilledButton(
                                height: 42,
                                text: isComplete ? "CONTINUE" : "TRY AGAIN",
                                fontSize: 18,
                                fontFamily: AppFonts.poppins,
                                color: AppColors.accentOrange,
                                command: () {},
                                borderRadius: 8)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 19, bottom: 19),
                        child: SizedBox(
                          width: 177,
                          child: Row(
                            children: [
                              AppFilledButton(
                                  height: 42,
                                  text: "BACK",
                                  fontSize: 18,
                                  fontFamily: AppFonts.poppins,
                                  color: AppColors.secondaryBlue,
                                  command: () {},
                                  borderRadius: 8)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
