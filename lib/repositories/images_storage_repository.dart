import 'package:image_picker/image_picker.dart';
import 'package:uptodo/services/images_storage_service.dart';

class ImagesStorageRepository {
  final ImagesStorageService _imagesStorageService;
  ImagesStorageRepository(this._imagesStorageService);

  Future<String?> saveImage(XFile image) {
    return _imagesStorageService.saveImage(image);
  }

  Future<String?> getImagePath(String imageId) {
    return _imagesStorageService.getImagePath(imageId);
  }
}
