import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:cloudinary/cloudinary.dart';

class ImageUtils {
  static Future<File?> pickImage() async {
    try {
      final imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return null;
      return File(imageFile.path);
    } catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
  }

  static Future<File> compressImage(File imageFile) async {
    final image = img.decodeImage(imageFile.readAsBytesSync());

    final resizedImage = img.copyResize(image!, width: 400);

    final compressedImage = img.encodeJpg(resizedImage, quality: 90);

    final compressedImageFile = File('${imageFile.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedImage);

    return compressedImageFile;
  }

  static Future<String?> uploadImage({
    required Cloudinary cloudinary,
    required File imageFile,
  }) async {
    try {
      final response = await cloudinary.unsignedUpload(
        file: imageFile.path,
        uploadPreset: 'superpal',
        fileBytes: imageFile.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        progressCallback: (count, total) {
          print('Uploading image with progress: $count/$total');
        },
      );

      if (response.isSuccessful) {
        print('Get your image from: ${response.secureUrl}');
        return response.secureUrl;
      } else {
        print('Error uploading image. Please check Cloudinary setup.');
        return null;
      }
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  static Future<void> deleteImage({
    required Cloudinary cloudinary,
    required String? publicImageId,
  }) async {
    try {
      if (publicImageId == null || publicImageId.isEmpty) {
        print('Image ID is empty. Cannot delete.');
        return;
      }

      final response = await cloudinary.destroy(
        publicImageId,
        resourceType: CloudinaryResourceType.image,
        invalidate: false,
      );

      if (response.isSuccessful) {
        print('Image deleted successfully');
      } else {
        print('Error deleting image. Please check Cloudinary setup.');
      }
    } catch (error) {
      print('Error deleting image: $error');
    }
  }
}
