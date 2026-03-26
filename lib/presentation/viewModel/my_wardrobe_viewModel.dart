import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';

class MyWardrobeViewModel with ChangeNotifier {
  final FirebaseServices services = FirebaseServices();

  //---[Variables]---
  List<ClothingModel> outfits = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //---[Get Outfit And Details]---

  Future<List<ClothingModel>> getOutFitData() async {
    _isLoading = true;

    try {
      outfits = [];
      outfits = await services.getOutfit();
      return outfits;
    } catch (e) {
      print(e);
      throw 'Something Went Wrong';
    } finally {
      _isLoading = false;
    }
  }

  //---[Delete Outfits From Firebase]---

  Future<void> deleteOutfit(String id) async {
    await services.removeOutfit(id);
    notifyListeners();
  }

  //---[Toggle Favourite Outfits in Firebase]---
  Future<void> toggleFavorite(String id, bool currentValue) async {
    await services.toggleFavorite(id, currentValue);
  }
}
