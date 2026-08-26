import 'package:flutter/material.dart';
import 'package:original_stock/screens/home_screen.dart';

class CartItem {
  final ProductModel product;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  double get unitPrice {
    final cleaned = product.price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  double get totalPrice => unitPrice * quantity;
}

class ProviderProduct extends ChangeNotifier {
  ProductModel? selectedProduct;
  final List<CartItem> _cartItems = [];
  final List<ProductModel> _wishlist = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<ProductModel> get wishlist => List.unmodifiable(_wishlist);
  int get wishlistCount => _wishlist.length;

  bool isProductInWishlist(ProductModel product) {
    return _wishlist.any(
      (p) => p.name == product.name && p.image == product.image,
    );
  }

  void toggleWishlist(ProductModel product) {
    if (isProductInWishlist(product)) {
      _wishlist.removeWhere(
        (p) => p.name == product.name && p.image == product.image,
      );
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  void selectedproduct(ProductModel? product) {
    selectedProduct = product;
    notifyListeners();
  }

  void addToCart(ProductModel product, String size, String color) {
    final existingIndex = _cartItems.indexWhere(
      (item) =>
          item.product.name == product.name &&
          item.size == size &&
          item.color == color,
    );
    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      _cartItems.add(
        CartItem(
          product: product,
          size: size,
          color: color,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _cartItems.remove(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => _cartItems.isEmpty ? 0.0 : 4.50;

  double get deliveryCharge => 0.0;

  double get totalPayment => subtotal + tax + deliveryCharge;

  int get totalItemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}

