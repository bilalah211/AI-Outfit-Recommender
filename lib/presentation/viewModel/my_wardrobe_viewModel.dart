import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyWardrobeViewModel with ChangeNotifier {
  final FirebaseServices services = FirebaseServices();

  //---[Variables]---
  List<ClothingModel> outfits = [];
  List<ClothingModel> favoriteOutfits = [];

  bool _isLoading = false;

  //---[Getter Methods]---

  bool get isLoading => _isLoading;

  //---[Setter Methods]---
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //---[Get Outfit And Details]---

  Future<List<ClothingModel>> getOutFitData() async {
    _isLoading = true;
    notifyListeners();

    try {
      outfits = [];
      outfits = await services.getOutfit();
      return outfits;
    } catch (e) {
      print(e);
      throw 'Something Went Wrong';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //---[Delete Outfits From Firebase]---

  Future<void> deleteOutfit(String id, index) async {
    await services.removeOutfit(id);
    outfits.removeAt(index);
    notifyListeners();
  }

  //---[Toggle Favourite Outfits in Firebase]---
  Future<void> toggleFavorite(String id) async {
    final index = outfits.indexWhere((e) => e.id == id);

    if (index == -1) return;
    notifyListeners();
    final oldValue = outfits[index].isFavorite;
    final newValue = !oldValue;

    outfits[index].isFavorite = newValue;
    notifyListeners();
    await FirebaseFirestore.instance.collection('My Wardrobe').doc(id).update({
      'isFavorite': newValue,
    });
  }

  Future<void> loadOutfits() async {
    try {
      _setLoading(true);
      outfits = await services.getFavoriteOutfits();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
