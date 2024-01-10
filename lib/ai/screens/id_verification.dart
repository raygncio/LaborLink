import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborlink/ai/helpers/anomaly_detection.dart';
import 'package:laborlink/ai/screens/face_verification.dart';
import 'package:laborlink/ai/screens/splash_id.dart';
import 'package:laborlink/ai/screens/verdict.dart';
import 'package:laborlink/ai/widgets/id_scan.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/results/anomaly_results.dart';

class IdVerification extends StatefulWidget {
  const IdVerification({super.key, required this.data});

  final List<Map<String, dynamic>> data;

  @override
  State<IdVerification> createState() {
    return _IdVerificationState();
  }
}

class _IdVerificationState extends State<IdVerification> {
  late AnomalyDetection anomalyDetection;
  List<Map<String, dynamic>> files = [];
  List<String> outputs = []; // for processing outputs
  File? image;
  String? type;

  final ValueNotifier<int> _currentFileIndex = ValueNotifier(0);

  //var _currentFileIndex = 0;
  var output = '';
  var _isSuccessful = false;
  var _hasAnomaly = false;
  var _isExiting = false;
  var _hasAProblem = false;

  _loadFiles() {
    files = widget.data;
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%$files');
    setState(() {});
  }

  _autoNext() {
    // runs every time file index change
    _currentFileIndex.addListener(() {
      print('******LISTENER CALLED ${_currentFileIndex.value}');

      if (_currentFileIndex.value < files.length) {
        _verifyImages();
      }

      if (_currentFileIndex.value >= files.length) {
        _interpretOutputs();
        // upload results to Firebase
        _recordResults();

        setState(() {
          _isExiting = true;
        });
      }
    });
  }

  _interpretOutputs() {
    for (var result in outputs) {
      if (result == 'hasanomaly') {
        setState(() {
          _hasAProblem = true;
        });
        return;
      }
    }
  }

  _getImages() {
    List<File> imageFiles = [];
    for (var id in files) {
      imageFiles.add(id['file']);
    }

    return imageFiles;
  }

  Future<void> _verifyImages() async {
    print('>>>>>>>> Verifiying Images');
    String? result;

    setState(() {
      _hasAnomaly = false; // reset to default values
      _isSuccessful = false;
      image = files[_currentFileIndex.value]['file'];
      type = files[_currentFileIndex.value]['type'];
    });

    if (files[_currentFileIndex.value].isNotEmpty &&
        files[_currentFileIndex.value]['file'] != null) {
      //print('************************$files');
      result = await anomalyDetection.getVerificationData(
        files[_currentFileIndex.value]['file'],
        files[_currentFileIndex.value]['type'],
      );
    }

    if (result != 'hasanomaly' && result != 'noanomaly') {
      result = 'Something went wrong';
    } else {
      setState(() {
        _isSuccessful = true;
      });
    }

    if (result == 'hasanomaly') {
      setState(() {
        _hasAnomaly = true;
      });
    }

    // for verdict
    if (result != null) outputs.add(result);

    Timer(const Duration(seconds: 3), () {
      setState(() {
        output = result!;
        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$output');

        _currentFileIndex.value++;
      });
    });
  }

  _recordResults() async {
    DatabaseService service = DatabaseService();
    AnomalyResults anomalyResults;

    for (var i = 0; i < files.length; i++) {
      // Upload files to Firebase Storage
      String imageUrl = await service.uploadId(i.toString(), files[i]['file']);

      anomalyResults = AnomalyResults(
          idType: files[i]['type'], attachment: imageUrl, result: outputs[i]);
      await service.addAnomalyResult(anomalyResults);
    }

    print('############################## RECORDING RESULTS!!!');
  }

  @override
  void initState() {
    anomalyDetection = AnomalyDetection();
    _loadFiles();
    _verifyImages();
    _autoNext();

    super.initState();
  }

  @override
  void dispose() {
    _currentFileIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if finish verifying IDs
    if (_isExiting) {
      // if there's at least 1 anomaly
      if (_hasAProblem) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => VerdictPage(
                isSuccessful: false,
                outputs: outputs,
              ),
            ),
          );
        });
        // if there are no anomalies
      } else {
        Timer(const Duration(seconds: 7), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => FaceVerificationPage(
                idImages: _getImages(),
              ),
            ),
          );
        });
        return const SplashId();
      }
    }

    // *** ID SCAN CONTENTS ***

    // id results
    Widget results = const Icon(
      Icons.check_circle,
      color: AppColors.green,
    );
    if (_hasAnomaly) {
      results = const Icon(
        Icons.error,
        color: AppColors.pink,
      );
    }

    // empty
    Widget content = const SizedBox();

    if (image != null) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IdScan(image: image!),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verifying your ${type!.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.medium,
                      fontSize: 15),
                ),
                const SizedBox(
                  width: 15,
                ),
                _isSuccessful ? results : const CircularProgressIndicator(),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: content,
    );
  }
}
