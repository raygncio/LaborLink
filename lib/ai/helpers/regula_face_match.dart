import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_face_api_beta/face_api.dart' as Regula;

class RegulaFaceMatch {
  var faceImage = Regula.MatchFacesImage();
  var idImage = Regula.MatchFacesImage();

  Future<double> matchFaces(
      {required Uint8List face, required Uint8List id}) async {
    double result = 0.0;

    faceImage.bitmap = base64Encode(face);
    faceImage.imageType = Regula.ImageType.PRINTED;
    idImage.bitmap = base64Encode(id);
    idImage.imageType = Regula.ImageType.PRINTED;

    if (faceImage.bitmap == null ||
        faceImage.bitmap == "" ||
        idImage.bitmap == null ||
        idImage.bitmap == "") return -1;

    var request = Regula.MatchFacesRequest();
    request.images = [faceImage, idImage];

    // Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
    //   var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
    //   Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
    //           jsonEncode(response!.results), 0.75)
    //       .then((str) {
    //     print('>>>>>>>>>>>>>>>>>>>>>>> regula face match');
    //     print(response);
    //     print(str);
    //     var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
    //         json.decode(str));
    //     split!.matchedFaces.length > 0
    //         ? result = (split.matchedFaces[0]!.similarity! * 100)
    //         : result = 0;
    //     print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$result');
    //     return result;
    //   });
    // });

    var send = await Regula.FaceSDK.matchFaces(jsonEncode(request));
    var response = Regula.MatchFacesResponse.fromJson(json.decode(send));

    var string = await Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results), 0.75);

    print('>>>>>>>>>>>>>>>>>>>>>>> regula face match');
    print(response);
    print(string);

    var split =
        Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(string));

    split!.matchedFaces.length > 0
        ? result = (split.matchedFaces[0]!.similarity! * 100)
        : result = 0;
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$result');
    return result;
  }
}
