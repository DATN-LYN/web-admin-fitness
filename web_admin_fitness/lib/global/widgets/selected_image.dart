import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage extends StatelessWidget {
  const SelectedImage({super.key, required this.image});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: !kIsWeb
          ? Image.file(
              File(image.path),
              fit: BoxFit.fitWidth,
            )
          : FutureBuilder(
              future: image.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final bytes = snapshot.data;
                  return Image.memory(bytes!);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
    );
  }
}
