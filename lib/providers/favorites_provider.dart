import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<int> _favoriteProductIds = [];

  List<int> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }
}