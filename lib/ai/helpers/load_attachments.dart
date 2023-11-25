import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class LoadAttachments {
  // FAKE DETECTION TEST
  List<Map<String, String>> attachments = [
    {'type': 'tesda', 'image': 'images/tesda1.jpg'}, // tesda legit
    {'type': 'tesda', 'image': 'images/fake.jpg'}, // tesda fake
    {
      'type': 'tesda',
      'image': 'images/postalid-marcus-ignacio.jpg'
    }, // tesda outlier
    {'type': 'nbi', 'image': 'images/nbi1.JPG'}, // nbi legit
    {'type': 'nbi', 'image': 'images/nbi1.JPG'}, // nbi fake
    {'type': 'nbi', 'image': 'images/tesda1.jpg'}, // nbi outlier
  ];

  // BOTH
  // 2 max ID
  List<Map<String, String>> fileAttachments = [
    {'type': 'nbi', 'image': 'images/nbi-marcus.jpg'}, // tesda legit
    {'type': 'tesda', 'image': 'images/tesda-marcus.jpg'}, // tesda fake
  ];

  Future<List<Map<String, dynamic>>> loadAttachmentsTest() async {
    List<Map<String, String>> files = attachments;
    List<Map<String, dynamic>> filesToLoad = [];

    for (int i = 0; i < files.length; i++) {
      File file = await _getImageFileFromAssets(files[i]['image']!);
      filesToLoad.add({
        'type': 'nbi',
        'file': file,
      });
    }

    print('>>>>>>>>>>>>>>>>>>>>>>$filesToLoad');
    return filesToLoad;
    
  }

  Future<Map<String, dynamic>> loadAttachmentsOne() async {
    File file = await _getImageFileFromAssets(fileAttachments[0]['image']!);
    return {'type': 'nbi', 'file': file};
  }

  Future<List<Map<String, dynamic>>> loadAttachmentsTwo() async {
    File file = await _getImageFileFromAssets(fileAttachments[0]['image']!);
    File file2 = await _getImageFileFromAssets(fileAttachments[1]['image']!);
    return [
      {
        'type': 'nbi',
        'file': file,
      },
      {
        'type': 'tesda',
        'file': file2,
      },
    ];
  }

  // convert asset image to file
  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
}
