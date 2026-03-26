import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImage() async {
    XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (file != null) {
      print("Picked file path: ${file.path}");
      return File(file.path);
    }
    return null;
  }
}
