import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  // Filter state variables
  String _selectedCondition = 'All';
  RangeValues _priceRange = const RangeValues(0, 5000);
  String _currentSort = 'Featured';

  ThemeMode get themeMode => _themeMode;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Filter getters
  String get selectedCondition => _selectedCondition;
  RangeValues get priceRange => _priceRange;
  String get currentSort => _currentSort;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Filter methods
  void setSelectedCondition(String condition) {
    _selectedCondition = condition;
    notifyListeners();
  }

  void setPriceRange(RangeValues priceRange) {
    _priceRange = priceRange;
    notifyListeners();
  }

  void setCurrentSort(String sort) {
    _currentSort = sort;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCondition = 'All';
    _priceRange = const RangeValues(0, 5000);
    _currentSort = 'Featured';
    notifyListeners();
  }
}
