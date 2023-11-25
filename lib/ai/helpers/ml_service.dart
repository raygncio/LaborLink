import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img_lib;

import 'package:laborlink/ai/utils/utils.dart';

class MLService {
  late Interpreter interpreter;
  List? predictedArray; // convert image to array for comparison

  String compare(List<dynamic> predictedArray, List<dynamic> predictedArray_2) {
    int minDist = 999;
    double threshold = 0.9;
    var dist = euclideanDistance(predictedArray, predictedArray_2);
    print('************************************************************$dist');
    if (dist <= threshold && dist < minDist) {
      return 'match';
    } else {
      return 'nomatch';
    }
  }

  // Map {type: id or camera, image:, face:}
  Future predict(Map<String, dynamic> data) async {
    // identify if image or file

    // tflite standard process
    List input = await _preProcess(data); // returns float32list for input
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    // load tflite model
    await initializeInterpreter();

    // actual tensorflow predict/evaluate
    interpreter.run(input, output);
    output = output.reshape([192]);

    predictedArray = List.from(output);

    interpreter.close();

    return predictedArray;
  }

  //  used to calculate the distance between any two points in
  // two- dimensional space, and also to measure the absolute
  // distance between points in N-dimensional space.

  // For face recognition, smaller values indicate
  // more similar faces.
  euclideanDistance(List l1, List l2) {
    double sum = 0;
    for (int i = 0; i < l1.length; i++) {
      sum += pow((l1[i] - l2[i]), 2);
    }

    return pow(sum, 0.5);
  }

  // for loading model
  initializeInterpreter() async {
    //Delegate? delegate;
    final interpreterOptions = InterpreterOptions();
    try {
      if (Platform.isAndroid) {
        //delegate = GpuDelegateV2(options: GpuDelegateOptionsV2());
        interpreterOptions.addDelegate(XNNPackDelegate());
      }

      //var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);

      interpreter = await Interpreter.fromAsset(
          'assets/models/mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      printIfDebug('Failed to load model.');
      printIfDebug(e);
    }
  }

  // crop face from image
  Future<List> _preProcess(Map<String, dynamic> data) async {
    img_lib.Image croppedImage = await _cropFace(data);
    img_lib.Image img = img_lib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = _imageToByteListFloat32(img);
    return imageAsList;
  }

  // actual cropping
  Future<img_lib.Image> _cropFace(Map<String, dynamic> data) async {
    img_lib.Image? convertedImage;

    // identifies if camera or id type

    if (data['type'] == 'camera') {
      img_lib.Image? img = await _convertCameraImage(data['image']);
      convertedImage = img;
    }

    if (data['type'] == 'id') {
      img_lib.Image? img = _convertFileImage(data['image']);
      convertedImage = img;
    }

    Face faceDetected = data['face'];

    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    img_lib.Image croppedImage = img_lib.copyCrop(
      convertedImage!,
      x.round(),
      y.round(),
      w.round(),
      h.round(),
    );

    if (data['type'] == 'camera') {
      croppedImage = img_lib.copyRotate(croppedImage, 90);
    }

    return croppedImage;
  }

  // convert camera image to image
  Future<img_lib.Image?> _convertCameraImage(CameraImage image) async {
    //var img = convertToImage(image);
    var img = await convertYUV420toImageColor(image);
    //img1 = img_lib.copyRotate(img1!, -90);
    return img;
  }

  // convert file image to image
  img_lib.Image? _convertFileImage(File file) {
    List<int> imageBase64 = file.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    var img = img_lib.decodeImage(uint8list);
    return img;
  }

  // convert image to bytes for comparing
  Float32List _imageToByteListFloat32(img_lib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img_lib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (img_lib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (img_lib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  static const shift = (0xFF << 24);
  Future<img_lib.Image?> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;

      print("uvRowStride: " + uvRowStride.toString());
      print("uvPixelStride: " + uvPixelStride.toString());

      // imgLib -> Image package from https://pub.dartlang.org/packages/image
      var img = img_lib.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final int uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          // Calculate pixel color
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          img.data[index] = shift | (b << 16) | (g << 8) | r;
        }
      }

      return img;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  // FOR DEBUGGING ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Future<List<int>> getIntImage(Map<String, dynamic> data) async {
    img_lib.Image? convertedImage;

    // identifies if camera or id type

    if (data['type'] == 'camera') {
      img_lib.Image? img = await _convertCameraImage(data['image']);
      convertedImage = img;
    }

    if (data['type'] == 'id') {
      img_lib.Image? img = _convertFileImage(data['image']);
      convertedImage = img;
    }

    Face faceDetected = data['face'];

    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    img_lib.Image croppedImage = img_lib.copyCrop(
      convertedImage!,
      x.round(),
      y.round(),
      w.round(),
      h.round(),
    );

    if (data['type'] == 'camera') {
      croppedImage = img_lib.copyRotate(croppedImage, 90);
    }

    img_lib.PngEncoder pngEncoder = new img_lib.PngEncoder(level: 0, filter: 0);
    List<int> png = pngEncoder.encodeImage(croppedImage);

    return png;
  }
}
