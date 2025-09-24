import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isProcessingOrder = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isProcessingOrder => _isProcessingOrder;
  bool get isEmpty => _items.isEmpty;

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int getItemQuantity(Product product) {
    final item =
        _items.where((item) => item.product.id == product.id).firstOrNull;
    return item?.quantity ?? 0;
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingItemIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      final updatedItem = _items[existingItemIndex].copyWith(
        quantity: _items[existingItemIndex].quantity + quantity,
      );
      _items[existingItemIndex] = updatedItem;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeItem(product);
      return;
    }

    final itemIndex =
        _items.indexWhere((item) => item.product.id == product.id);
    if (itemIndex != -1) {
      final updatedItem = _items[itemIndex].copyWith(quantity: quantity);
      _items[itemIndex] = updatedItem;
      notifyListeners();
    }
  }

  void incrementQuantity(Product product) {
    final itemIndex =
        _items.indexWhere((item) => item.product.id == product.id);
    if (itemIndex != -1) {
      final currentQuantity = _items[itemIndex].quantity;
      updateQuantity(product, currentQuantity + 1);
    }
  }

  void decrementQuantity(Product product) {
    final itemIndex =
        _items.indexWhere((item) => item.product.id == product.id);
    if (itemIndex != -1) {
      final currentQuantity = _items[itemIndex].quantity;
      if (currentQuantity > 1) {
        updateQuantity(product, currentQuantity - 1);
      } else {
        removeItem(product);
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<void> processOrder() async {
    if (_items.isEmpty) return;

    _isProcessingOrder = true;
    notifyListeners();

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    _isProcessingOrder = false;
    clearCart();
    notifyListeners();
  }

  void toggleItemFavorite(Product product) {
    final itemIndex =
        _items.indexWhere((item) => item.product.id == product.id);
    if (itemIndex != -1) {
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      final updatedItem = _items[itemIndex].copyWith(product: updatedProduct);
      _items[itemIndex] = updatedItem;
      notifyListeners();
    }
  }
}
