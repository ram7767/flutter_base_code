import 'dart:async';
import 'dart:convert';
import 'dart:html' as html; // For web environment
import 'package:http/http.dart' as http;

class ImageService {
  static Future<Map<String, dynamic>?> uploadImage(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<String>();

    // Read file as Data URL
    reader.onLoadEnd.listen((e) {
      completer.complete(reader.result as String);
    });

    reader.readAsDataUrl(file);

    try {
      final base64Image = await completer.future;
      final base64String = base64Image.split(',').last;

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/upload'),
        body: json.encode({'image': base64String}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Convert response body to JSON
      } else {
        print('Image upload failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  static Future<bool> pingServer() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/ping'));
      return response.statusCode == 200;
    } catch (e) {
      return false; // Return false if there is an error
    }
  }
}
