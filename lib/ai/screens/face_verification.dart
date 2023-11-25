import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:laborlink/ai/helpers/regula_face_match.dart';
import 'package:laborlink/ai/helpers/show_image.dart';
import 'package:laborlink/ai/screens/verdict.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/ai/widgets/common_widgets.dart';
import 'package:laborlink/ai/helpers/ml_service.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';

List<CameraDescription>? cameras;

class FaceVerificationPage extends StatefulWidget {
  const FaceVerificationPage({super.key, required this.idImages});

  final List<File> idImages; // nbi, tesda

  @override
  State<FaceVerificationPage> createState() {
    return _FaceVerificationPageState();
  }
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  List<Image> showImage = []; //for debugging
  var debugIndex = 0;

  List<Uint8List> regulaImages = []; // for regula face match
  List<double> regulaResults = [];
  final RegulaFaceMatch _regula = RegulaFaceMatch();

  late FaceDetector _faceDetector; // Google ML Vision
  final MLService _mlService = MLService(); // initialize mlservice
  List<Face> facesDetected = []; // storage for faces detected

  late CameraController _cameraController; // for camera controls and preview

  bool flash = false; // camera flash initially off
  bool isControllerInitialized = false; // for camera
  bool isCapturing = false;
  bool noFaceDetected = false;
  bool isDoneMatching = false;
  bool isMatch = false;
  List<String> results = []; // for verdict

  Future initializeCamera() async {
    await _cameraController.initialize();
    isControllerInitialized = true;
    _cameraController.setFlashMode(FlashMode.off);
    setState(() {}); // refresh entire subtree with new changes if any
  }

  // required parameter for face detection
  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation0deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    // since format is constraint to nv21 or bgra8888, both only have one plane
    // if (image.planes.length != 1) return null;

    //final plane = image.planes.first;

    // creating image metadata / image initialization
    InputImageMetadata firebaseImageMetadata = InputImageMetadata(
        rotation: rotationIntToImageRotation(
            _cameraController.description.sensorOrientation),
        format: InputImageFormat.bgra8888,
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        bytesPerRow:
            image.planes.map((Plane plane) => plane.bytesPerRow).first);

    Uint8List bytes = Uint8List.fromList(
      image.planes.fold(
          <int>[],
          (List<int> previousValue, element) =>
              previousValue..addAll(element.bytes)),
    );

    // create the image from initialization
    InputImage firebaseVisionImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: firebaseImageMetadata,
    );

    // updates facesDetected
    await firebaseProcessImage(firebaseVisionImage);
  }

  Future<void> detectFacesFromIds(File file) async {
    // file to inputimage
    InputImage firebaseVisionImage = InputImage.fromFile(file);

    // updates facesDetected
    await firebaseProcessImage(firebaseVisionImage);
  }

  Future<void> firebaseProcessImage(InputImage firebaseVisionImage) async {
    // automatically processes and calculates the images
    // detects faces in an image and returns a string
    var result = await _faceDetector.processImage(firebaseVisionImage);
    if (result.isNotEmpty) {
      facesDetected = result; // list of faces
    }
  }

  Future<void> compareImages(List<dynamic> outputCameraImage) async {
    // returns prediction from file image/s
    final List<File> idImages = widget.idImages;

    for (int i = 0; i < idImages.length; i++) {
      // refresh detected faces, now from file image
      File file = idImages[i];

      // update faces
      await detectFacesFromIds(file);

      // DEBUG ********************************
      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$facesDetected');

      // for debugging -> show images *******************************************
      List<int> intImage = await _mlService
          .getIntImage(toMap(type: 'id', image: file, face: facesDetected[0]));
      showImage.add(Image.memory(Uint8List.fromList(intImage)));
      // ************************************************************************

      // for regula facematch
      regulaImages.add(Uint8List.fromList(intImage));

      List<dynamic> outputFileImage = await _mlService.predict(
        toMap(
          type: 'id',
          image: file,
          face: facesDetected[0],
        ),
      );

      String result = _mlService.compare(outputCameraImage, outputFileImage);
      results.add(result);
    }

    if (idImages.length > 1) {
      if (!results.contains('nomatch')) {
        setState(() {
          isMatch = true;
        });
      }
    } else {
      if (results.contains('match')) {
        setState(() {
          isMatch = true;
        });
      }
    }

    // note: this is redundant -> regula > custom model
    // FOR FALSE POSITIVES, check conditions on running regula after custom model
    // last stop double check using Regula Face Match API

    bool isGoodOnRegula = await regulaFaceMatch();
    print(
        '<<<<<<<<<<<<<<<<<<<<<<<<<prompting regula face match -> $isGoodOnRegula');
    if (results.contains('nomatch')) {
      if (isGoodOnRegula) {
        print('<<<<<<<<<<<<<<<<<<<<<<<<<$isGoodOnRegula');
        print('<<<<<<<<<<<<<<<<<<<<<<<<<$regulaResults');
        setState(() {
          isMatch = true;
        });
      } else {
        setState(() {
          isMatch = false;
        });
      }
    }

    setState(() {
      isDoneMatching = true;
    });
  }

  // MAIN FUNCTION AFTER VERIFYING MATCH
  Future<void> _predictFacesFromImage({required CameraImage image}) async {
    // run the process above
    // gets detected faces
    await detectFacesFromImage(image);

    // DEBUG ********************************
    print(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$facesDetected');

    if (facesDetected.isNotEmpty) {
      setState(() {
        noFaceDetected = false;
      });
      // for debugging -> show images *******************************************
      List<int> intImage = await _mlService.getIntImage(
          toMap(type: 'camera', image: image, face: facesDetected[0]));

      showImage.add(Image.memory(Uint8List.fromList(intImage)));
      // ****************************************************************

      // for regula facematch
      regulaImages.add(Uint8List.fromList(intImage));

      // returns prediction from camera image
      List<dynamic>? outputCameraImage = await _mlService.predict(
        toMap(
          type: 'camera',
          image: image,
          face: facesDetected[0],
        ),
      );

      await compareImages(outputCameraImage!);
    }

    // Mounting is the process of creating the state of a StatefulWidget
    // and attaching it to a BuildContext.

    // When a widget is unmounted in the dispose method of a StatefulWidget, it loses its state.
    // if unmounted, state can't be updated and setState can no longer be called.

    // So when you check if a widget is mounted,
    // you're checking if its state can still be updated.
    if (mounted) setState(() {});

    // only take picture after face/s is/are detected
    await takePicture();
  }

  Map<String, dynamic> toMap(
      {required String type, required dynamic image, required Face face}) {
    return {
      'type': type,
      'image': image,
      'face': face,
    };
  }

  Future<void> takePicture() async {
    if (facesDetected.isNotEmpty) {
      await _cameraController.stopImageStream(); // stop camera
      XFile file = await _cameraController
          .takePicture(); // take picture from cam controller itself
      file = XFile(file.path); // saves a file
      _cameraController.setFlashMode(FlashMode.off);
    } else {
      setState(() {
        noFaceDetected = true;
      });
    }
  }

  Future<bool> regulaFaceMatch() async {
    bool isGoodOnRegula = true;

    if (regulaImages.isEmpty) return false;

    for (int i = 1; i < regulaImages.length; i++) {
      regulaResults.add(
        await _regula.matchFaces(
          face: regulaImages[0],
          id: regulaImages[i],
        ),
      );
    }

    print('%%%%%%%%%%%% in regula face match function -> $isGoodOnRegula');
    for (var result in regulaResults) {
      if (result < 60.0) {
        isGoodOnRegula = false;
      }
    }

    print('%%%%%%%%%%%% in regula face match function -> $isGoodOnRegula');
    return isGoodOnRegula;
  }

  @override
  void initState() {
    // cameras![1] -> front cam
    _cameraController = CameraController(cameras![1], ResolutionPreset.high);
    initializeCamera(); // initialize camera controls

    // captures the face area
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FOR DISPLAYING RESULTS *********************************
    bool debug = false; // true to enable debugging

    if (debug) {
      if (isDoneMatching) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ShowImage(
                        images: showImage,
                        regulaResults: regulaResults,
                      )));
        });
      }
    } else {
      if (isDoneMatching) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (ctx) => VerdictPage(
                    outputs: results,
                    regulaOutputs: regulaResults,
                    isSuccessful: isMatch)),
          );
        });
      }
    }
    // **********************************************

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        // unfocus upon tapping again?
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.dirtyWhite,
        body: Stack(
          children: [
            // for previewing image
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: isControllerInitialized
                  ? CameraPreview(
                      _cameraController) // creates a preview for the widget
                  : null,
            ),
            // on tap of camera preview
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Lottie.asset('assets/animations/face.json',
                          width: MediaQuery.of(context).size.width),
                    ),
                  ),
                  if (noFaceDetected)
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 40,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: AppColors.dirtyWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'No Face Detected',
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                              textColor: AppColors.primaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  if (!noFaceDetected)
                    const SizedBox(
                      height: 5,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CAPTURE BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: CommonWidgets.customExtendedButton(
                          text: 'Capture',
                          context: context,
                          isClickable: isCapturing ? false : true,
                          width: 100,
                          onTap: () {
                            bool canProcess = false;

                            if (isCapturing) return null;

                            // create a stream of images
                            // capture the first frame that is displayed
                            _cameraController.startImageStream(
                              (CameraImage image) async {
                                // disable button upon startImageStream
                                setState(() {
                                  isCapturing = true;
                                });

                                // prevent from taking again
                                // while predicting faces from image is running
                                if (canProcess) return;

                                canProcess = true;
                                // passes CameraImage
                                // passes predict function once
                                _predictFacesFromImage(image: image).then(
                                  (value) {
                                    canProcess = false;
                                  },
                                );
                                return null;
                              },
                            );
                          },
                        ),
                      ),

                      // FLASH BUTTON
                      IconButton(
                        icon: Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: AppColors.dirtyWhite,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            flash = !flash; // toggle on/off
                          });
                          flash
                              ? _cameraController.setFlashMode(FlashMode.torch)
                              : _cameraController.setFlashMode(FlashMode.off);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
