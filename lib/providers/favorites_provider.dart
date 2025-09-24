import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get hasFavorites => _favoriteIds.isNotEmpty;

  List<Product> getFavoriteProducts(List<Product> allProducts) {
    return allProducts
        .where((product) => _favoriteIds.contains(product.id))
        .toList();
  }

  bool isFavorite(Product product) {
    return _favoriteIds.contains(product.id);
  }

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }

  void addToFavorites(Product product) {
    _favoriteIds.add(product.id);
    notifyListeners();
  }

  void removeFromFavorites(Product product) {
    _favoriteIds.remove(product.id);
    notifyListeners();
  }

  void clearAllFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }

  void toggleMultipleFavorites(List<Product> products) {
    for (final product in products) {
      toggleFavorite(product);
    }
  }
}
