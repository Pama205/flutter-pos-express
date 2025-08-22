import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(CartItem item) {
    // Comprueba si el producto ya está en el carrito
    final existingItemIndex = _items.indexWhere(
      (element) => element.product.id == item.product.id,
    );

    if (existingItemIndex >= 0) {
      // Si ya existe, incrementa la cantidad
      _items[existingItemIndex].incrementQuantity();
    } else {
      // Si no existe, agrégalo
      _items.add(item);
    }
    notifyListeners();
  }

  void removeProduct(CartItem item) {
    _items.removeWhere((element) => element.product.id == item.product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    for (var item in _items) {
      total += item.quantity * item.product.price;
    }
    return total;
  }

  // Agrega este getter para contar el total de artículos
  int get itemCount {
    var count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }
}