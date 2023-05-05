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

  static Future<String?> uploadImage(XFile image) async {
    final cloudinary = CloudinaryPublic(
      'dltbbrtlv',
      'e9xnvbev',
      cache: false,
    );

    print(image);

    // var resp = await http.post(
    //   Uri.parse(
    //       'https://api.cloudinary.com/v1_1/dltbbrtlv/upload?file=${image.path}&upload_preset=e9xnvbev&api_key=${Constants.cloudinaryApiKey}&public_id=samples/newphoto'),
    // );
    // var data = json.decode(resp.body);

    try {
      List<int> bytes = [];
      if (kIsWeb) {
        bytes = await image.readAsBytes();
      }
      CloudinaryResponse response = await cloudinary.uploadFile(
        !kIsWeb
            ? CloudinaryFile.fromFile(
                image.path,
                folder: 'category',
                resourceType: CloudinaryResourceType.Image,
              )
            : CloudinaryFile.fromBytesData(
                bytes,
                folder: 'category',
                identifier: image.name,
              ),
      );

      return response.url;
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
    return null;

    // cloudinary.uploadFile(
    //   CloudinaryFile.fromFile(
    //     image.path,
    //     folder: 'samples/people',
    //   ),
    // );
  }

  static Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
