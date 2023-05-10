import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage extends StatelessWidget {
  const SelectedImage({
    super.key,
    required this.image,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.fit = BoxFit.fitWidth,
  });

  final XFile image;
  final double borderRadius;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: !kIsWeb
          ? Image.file(
              File(image.path),
              fit: fit,
              width: width,
              height: height,
            )
          : FutureBuilder(
              future: image.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final bytes = snapshot.data;
                  return Image.memory(
                    bytes!,
                    fit: fit,
                    width: width,
                    height: height,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
    );
  }
}
