import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborlink/ai/screens/face_verification.dart';
import 'package:laborlink/ai/screens/splash_id.dart';
import 'package:laborlink/ai/widgets/id_scan.dart';
import 'package:laborlink/ai/style.dart';

class IdClient extends StatefulWidget {
  const IdClient({super.key, required this.data});

  final List<Map<String, dynamic>> data;

  @override
  State<IdClient> createState() {
    return _IdClientState();
  }
}

class _IdClientState extends State<IdClient> {
  List<Map<String, dynamic>> files = [];
  List<String> outputs = []; // for processing outputs
  File? image;
  String? type;

  _loadFiles() {
    files = widget.data;
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%$files');
    setState(() {
      image = files[--files.length]['file'];
    });
  }

  _getImages() {
    List<File> imageFiles = [];
    for (var id in files) {
      imageFiles.add(id['file']);
    }

    return imageFiles;
  }

  _toFaceVerif() {
    Timer(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => FaceVerificationPage(
            idImages: _getImages(),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _loadFiles();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    Timer(const Duration(seconds: 3), () {
      content = const SplashId();
      _toFaceVerif();
    });

    content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IdScan(image: image!),
          const SizedBox(
            height: 15,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: content,
    );
  }
}
