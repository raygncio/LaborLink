import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laborlink/ai/helpers/load_attachments.dart';
import 'package:laborlink/ai/screens/id_verification.dart';
import 'package:laborlink/ai/screens/splash_one.dart';
import 'package:laborlink/ai/style.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({super.key});

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  LoadAttachments anomalyDetectionTest = LoadAttachments();
  var _isLoading = false;
  List<Map<String, dynamic>> test = [];

  Future<void> _loadImages() async {
    test = await anomalyDetectionTest.loadAttachmentsTwo();
  }

  @override
  void initState() {
    _loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashOnePage();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'dummy',
              style: getTextStyle(
                  textColor: AppColors.primaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.medium,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                Timer(
                  const Duration(seconds: 5),
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => IdVerification(
                          data: test,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Submit',
                style: getTextStyle(
                    textColor: AppColors.white,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.medium,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
