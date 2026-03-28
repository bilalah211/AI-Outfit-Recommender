import 'dart:io';

import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/data/services/cloudinary_services.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';

class UploadImageVM with ChangeNotifier {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  //---[Variables]---

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //---[Public Methods]---

  //---[Save Data]---
  Future<void> saveData(
    File imageFile,
    String category,
    String color,
    String season,
  ) async {
    try {
      _setLoading(true);

      //---[Upload Image]---
      final imageUrl = await _cloudinaryService.uploadImage(imageFile);

      //---[Create Model]---
      final clothingDetails = ClothingModel(
        id: '',
        image: imageUrl,
        category: category,
        color: color,
        season: season,
      );
      await _firebaseServices.saveOutfit(clothingDetails);
    } catch (e) {
      throw 'Something Went Wrong';
    } finally {
      _setLoading(false);
    }
  }

  //---[Loading Helper]---

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
