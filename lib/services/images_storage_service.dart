import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImagesStorageService {
  static const String cloudName = 'dmxqkiwbe';
  static const String uploadPreset = 'flutter_unsigned_preset';

  Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: path.basename(imageFile.path),
      ));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);
      return data['secure_url'];
    } else {
      print('Upload failed: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> deleteImage(String publicId) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dmxqkiwbe/image/destroy');
      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'api_key': '618879161137733',
          'signature': '7qFSrAfKqITwaKHBxg5PvKW2QCQ',
        },
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return jsonMap['result'] as String?;
      } else {
        print('Cloudinary delete failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error deleting image from Cloudinary: $e');
      return null;
    }
  }
}
