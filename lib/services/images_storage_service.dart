import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImagesStorageService {
  Future<String?> uploadImage(File imageFile) async {
    final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
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
    }

    return null;
  }

  Future<String?> deleteImage(String publicId) async {
    final String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
    final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final String signature = dotenv.env['CLOUDINARY_SIGNATURE'] ?? '';
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');
      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'api_key': apiKey,
          'signature': signature,
        },
      );
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return jsonMap['result'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
