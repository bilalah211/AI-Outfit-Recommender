import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:ai_outfit_recommender/data/services/openAi_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/outfit_recommendation_model.dart';

class OpenAIViewModel with ChangeNotifier {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final HuggingFaceService _huggingFace = HuggingFaceService();

  List<ClothingModel> _myWardrobe = [];
  List<OutfitRecommendationModel> outfits = [];

  final List<String> _recommendedImages = [];
  List<String> get recommendedImages => _recommendedImages;

  final List<ClothingModel> _recommendedItems = [];
  List<ClothingModel> get recommendedItems => _recommendedItems;

  //---[Variables]---
  String? aiResult;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSLoading = false;
  bool get isSLoading => _isSLoading;

  //---[Load Outfits]---

  Future<void> _loadOutfit() async {
    _myWardrobe = await _firebaseServices.getOutfit();
    if (kDebugMode) {
      print("Loaded ${_myWardrobe.length} items from wardrobe");
    }
  }

  //---[Get Outfit Recommendation]---

  Future<void> getOutfitRecommendation(String occasion, String weather) async {
    try {
      _isLoading = true;
      _recommendedImages.clear();
      _recommendedItems.clear();
      notifyListeners();

      await _loadOutfit();

      if (_myWardrobe.isEmpty) {
        if (kDebugMode) {
          print("Wardrobe is empty!");
        }
        _isLoading = false;
        notifyListeners();
        return;
      }

      final result = await _huggingFace.getRecommendation(
        wardrobe: _myWardrobe,
        occasion: occasion,
        weather: weather,
      );

      if (kDebugMode) {
        print("AI Result: $result");
      }

      final String aiTopId = (result['top'] ?? "").toString();
      final String aiBottomId = (result['bottom'] ?? "").toString();
      final String aiShoesId = (result['shoes'] ?? "").toString();

      if (kDebugMode) {
        print(
          "Looking for IDs - Top: $aiTopId, Bottom: $aiBottomId, Shoes: $aiShoesId",
        );
      }

      // Find items by ID
      for (var item in _myWardrobe) {
        if (item.id == aiTopId ||
            item.id == aiBottomId ||
            item.id == aiShoesId) {
          _recommendedImages.add(item.image);
          _recommendedItems.add(item);
          if (kDebugMode) {
            print("Found matching item: ${item.category} (${item.id})");
          }
        }
      }

      // If no items found by ID, try category matching as fallback
      if (_recommendedImages.isEmpty) {
        if (kDebugMode) {
          print("No items found by ID, trying category matching...");
        }

        // Try to match by category names
        for (var item in _myWardrobe) {
          final category = (item.category ?? "").toLowerCase();

          // Check if this item might be a top
          if (category.contains('shirt') ||
              category.contains('t-shirt') ||
              category.contains('blouse') ||
              category.contains('top')) {
            if (_recommendedItems
                .where(
                  (i) =>
                      i.category?.toLowerCase().contains('shirt') == true ||
                      i.category?.toLowerCase().contains('top') == true,
                )
                .isEmpty) {
              _recommendedImages.add(item.image);
              _recommendedItems.add(item);
              if (kDebugMode) {
                print("Fallback - Added top: ${item.category}");
              }
            }
          }
          // Check for bottom
          else if (category.contains('pant') ||
              category.contains('jean') ||
              category.contains('trouser') ||
              category.contains('short') ||
              category.contains('skirt')) {
            if (_recommendedItems
                .where(
                  (i) =>
                      i.category?.toLowerCase().contains('pant') == true ||
                      i.category?.toLowerCase().contains('jean') == true,
                )
                .isEmpty) {
              _recommendedImages.add(item.image);
              _recommendedItems.add(item);
              if (kDebugMode) {
                print("Fallback - Added bottom: ${item.category}");
              }
            }
          }
          // Check for shoes
          else if (category.contains('shoes') ||
              category.contains('sneaker') ||
              category.contains('boot')) {
            if (_recommendedItems
                .where(
                  (i) => i.category?.toLowerCase().contains('shoes') == true,
                )
                .isEmpty) {
              _recommendedImages.add(item.image);
              _recommendedItems.add(item);
              if (kDebugMode) {
                print("Fallback - Added shoes: ${item.category}");
              }
            }
          }
        }
      }

      if (kDebugMode) {
        print("Found ${_recommendedImages.length} matching items");
      }

      if (_recommendedImages.isEmpty) {
        if (kDebugMode) {
          print(
            "No matching items found. Wardrobe items: ${_myWardrobe.map((i) => "${i.category} (${i.id})").join(', ')}",
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getOutfitRecommendation: $e");
      }
      aiResult = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //---[Save Outfits]---

  Future<void> saveOutfit(String occasion, String weather) async {
    if (_recommendedImages.isEmpty) {
      if (kDebugMode) {
        print("No outfit to save");
      }
      return;
    }

    _isSLoading = true;
    notifyListeners();

    try {
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
      if (kDebugMode) {
        print(
          "Outfit saved successfully with ${_recommendedImages.length} images",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving outfit: $e");
      }
    } finally {
      _isSLoading = false;
      notifyListeners();
    }
  }
}
