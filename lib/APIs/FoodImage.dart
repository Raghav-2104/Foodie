import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../Keys/Unsplash.dart';

const accessKey = Unsplash.UnSplashACCESSKEY;

class FoodImage {
  static Future<String> getImage(String query) async {
    String url =
        'https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey';
    var response = await Dio().get(url);
    return response.data['results'][0]['urls']['small'];
  }

  static Future<void> downloadImg(String url, String name) async {
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Save the downloaded image to the documents directory
    File file = File('${appDocDir.path}/$name.jpg');
    await file.writeAsBytes(response.bodyBytes);
    // For example, you can save the image to a file or display it using Image.memory(bytes) widget.
    Uint8List imageBytes = response.bodyBytes;
    print('Image downloaded successfully and saved at: ${file.path}');
  } else {
    print('Failed to download image. Status code: ${response.statusCode}');
  }
}
}
