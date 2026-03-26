import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/data/models/outfit_recommendation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseServices with ChangeNotifier {
  //---[Variables]---
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //---[Save Outfit in Firebase]---
  Future<void> saveOutfit(ClothingModel clothingModel) async {
    await _db.collection('My Wardrobe').doc().set(clothingModel.toMap());
  }

  //---[GetOutfit From Firebase]---
  Future<List<ClothingModel>> getOutfit() async {
    final snapshot = await _db.collection('My Wardrobe').get();

    return snapshot.docs.map((doc) {
      return ClothingModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  //---[Delete Outfits From Firebase]---

  Future<void> removeOutfit(String id) async {
    await _db.collection('My Wardrobe').doc(id).delete();
  }

  //---[Toggle Favourite Outfits in Firebase]---

  Future<void> toggleFavorite(String id, bool currentValue) async {
    await _db.collection('My Wardrobe').doc(id).update({
      'isFavorite': !currentValue,
    });
  }

  //---[Save Recommended Outfits in Firebase]---

  Future<void> saveOutfitRecommendation(
    OutfitRecommendationModel outfitRecommendationModel,
  ) async {
    await _db
        .collection('Recommended Outfits')
        .doc()
        .set(outfitRecommendationModel.toMap());
  }

  //---[Get Recommended Outfits From Firebase]---

  Stream<List<OutfitRecommendationModel>> getRecommendedOutfits() {
    return _db.collection('Recommended Outfits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OutfitRecommendationModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}
