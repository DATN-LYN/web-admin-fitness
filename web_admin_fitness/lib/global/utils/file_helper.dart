import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FileHelper {
  static String getPathByPlatform(String path) {
    return Platform.isIOS ? path.split('file://').last : path;
  }

  static String getFileName(File file) {
    return basename(file.path);
  }

  static Future<String?> uploadImage(XFile image, String folderName) async {
    final cloudinary = CloudinaryPublic(
      'dltbbrtlv',
      'e9xnvbev',
      cache: false,
    );

    try {
      List<int> bytes = [];
      if (kIsWeb) {
        bytes = await image.readAsBytes();
      }
      CloudinaryResponse response = await cloudinary.uploadFile(
        !kIsWeb
            ? CloudinaryFile.fromFile(
                image.path,
                folder: folderName,
                resourceType: CloudinaryResourceType.Image,
              )
            : CloudinaryFile.fromBytesData(
                bytes,
                folder: folderName,
                identifier: image.name,
                resourceType: CloudinaryResourceType.Image,
              ),
      );

      return response.url;
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
    return null;
  }

  static Future<String?> uploadVideo(XFile video, String folderName) async {
    final cloudinary = CloudinaryPublic(
      'dltbbrtlv',
      'e9xnvbev',
      cache: false,
    );

    try {
      List<int> bytes = [];
      if (kIsWeb) {
        bytes = await video.readAsBytes();
      }
      CloudinaryResponse response = await cloudinary.uploadFile(
        !kIsWeb
            ? CloudinaryFile.fromFile(
                video.path,
                folder: folderName,
                resourceType: CloudinaryResourceType.Video,
              )
            : CloudinaryFile.fromBytesData(
                bytes,
                folder: folderName,
                identifier: video.name,
                resourceType: CloudinaryResourceType.Video,
              ),
      );

      return response.url;
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
    return null;
  }

  static Future<XFile?> pickVideo() async {
    return await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
  }

  static Future<XFile?> pickImage() async {
    return await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
  }
}
