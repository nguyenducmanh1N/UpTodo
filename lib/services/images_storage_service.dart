import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource, XFile;
import 'package:uptodo/constants/shared_preferences.dart';

class ImagesStorageService {
  final String imageKey = SharedPreferencesKeys.imagesKey;

  Future<String?> saveImage(XFile image) async {
    try {
      final String duplicateFilePath = (await getApplicationDocumentsDirectory()).path;
      final String fileName = basename(image.path);
      final String savedPath = '$duplicateFilePath/$fileName';
      await image.saveTo(savedPath);
      final String imageId = '${imageKey}_${DateTime.now().millisecondsSinceEpoch}';
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(imageId, savedPath);
      return imageId;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  Future<String?> getImagePath(String imageId) async {
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString(imageId);
    } catch (e) {
      print('Error getting image path: $e');
      return null;
    }
  }
}
