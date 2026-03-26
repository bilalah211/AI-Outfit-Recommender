import 'dart:convert';
import 'dart:io';
import 'package:ai_outfit_recommender/core/utils/app_strings.dart';
import 'package:ai_outfit_recommender/core/utils/app_urls.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = AppStrings.cloudName;
  final String uploadPreset = AppStrings.uploadPreset;

  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse(AppUrls.cloudinaryApiUrl);

    final request = http.MultipartRequest("POST", url);

    request.fields['upload_preset'] = AppStrings.uploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData = await response.stream.bytesToString();
      final data = jsonDecode(resData);

      return data['secure_url'];
    } else {
      throw Exception("Cloudinary upload failed");
    }
  }
}
