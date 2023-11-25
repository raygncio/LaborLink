import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

// Flask API -> pythonanywhere
// all ML code happens there

class AnomalyDetection {

  Future<String> getVerificationData(File image, String type) async {
    // converts image to bytes
    Uint8List imageBytes = await image.readAsBytes();

    // converts bytes to base64 string
    String base64string = base64.encode(imageBytes);

    //print(base64string);
    //print(type);

    const url = 'https://marcusray.pythonanywhere.com/api';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'content-type': 'multipart/form-data'},
      body: json.encode({
        'type': type,
        'image': base64string,
      }),
    );

    //print(response.body);
    var output = jsonDecode(response.body);

    return output['output'];
  }
}
