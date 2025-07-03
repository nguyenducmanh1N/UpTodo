import 'dart:io';

import 'package:uptodo/services/images_storage_service.dart';

class ImagesStorageRepository {
  final ImagesStorageService _imagesStorageService;
  ImagesStorageRepository(this._imagesStorageService);

  Future<String?> saveImage(File image) {
    return _imagesStorageService.uploadImage(image);
  }
}
