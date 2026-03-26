import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:ai_outfit_recommender/data/services/openAi_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/outfit_recommendation_model.dart';

class OpenAIViewModel with ChangeNotifier {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final GeminiService _geminiService = GeminiService();
  //---[Variables]---
  List<ClothingModel> _myWardrobe = [];
  List<OutfitRecommendationModel> outfits = [];

  List<String> _recommendedImages = [];
  List<String> get recommendedImages => _recommendedImages;
  String? aiResult;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSLoading = false;
  bool get isSLoading => _isLoading;

  //---[Load Outfits]---
  Future<void> _loadOutfit() async {
    _myWardrobe = await _firebaseServices.getOutfit();
  }

  //---[Get Outfit Recommendation]---
  Future<void> getOutfitRecommendation(String occasion, String weather) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _loadOutfit();
      notifyListeners();

      final result = await _geminiService.getRecommendation(
        wardrobe: _myWardrobe,
        occasion: occasion,
        weather: weather,
      );
      print("AI RESULT: $result");
      notifyListeners();
      recommendedImages.clear();
      print("WARDROBE: ${_myWardrobe.length}");
      final aiTop = result['top'].toString().toLowerCase();
      final aiBottom = result['bottom'].toString().toLowerCase();
      final aiShoes = result['shoes'].toString().toLowerCase();

      for (var item in _myWardrobe) {
        final category = item.category!.toLowerCase();

        if (category.contains(aiTop) ||
            category.contains(aiBottom) ||
            category.contains(aiShoes)) {
          _recommendedImages.add(item.image);
        }
      }
      notifyListeners();
      // await _firebaseServices.saveOutfitRecommendation(outfitRecommendationModel)
    } catch (e) {
      aiResult = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //---[Save Outfit Recommendation]---
  Future<void> saveOutfit(String occasion, String weather) async {
    if (_recommendedImages.isEmpty) return;
    _isSLoading = true;
    notifyListeners();

    final docRef = FirebaseFirestore.instance
        .collection('Recommended Outfits')
        .doc();

    final model = OutfitRecommendationModel(
      id: docRef.id,
      occasion: occasion,
      weather: weather,
      imageUrls: List.from(_recommendedImages),
    );

    await docRef.set(model.toMap());
    _isSLoading = false;
    notifyListeners();
  }
}
