import 'package:flutter/material.dart';
import 'package:original_stock/core/money.dart';
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

  double get unitPrice => parsePrice(product.price);

  double get totalPrice => unitPrice * quantity;
}

class ProviderProduct extends ChangeNotifier {
  ProductModel? selectedProduct;
  final List<CartItem> _cartItems = [];
  final List<ProductModel> _wishlist = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<ProductModel> get wishlist => List.unmodifiable(_wishlist);
  int get wishlistCount => _wishlist.length;

  bool _isSameProduct(ProductModel a, ProductModel b) {
    if (a.id.isNotEmpty && b.id.isNotEmpty) {
      return a.id == b.id;
    }
    return a.name == b.name && a.image == b.image;
  }

  bool isProductInWishlist(ProductModel product) {
    return _wishlist.any((p) => _isSameProduct(p, product));
  }

  void toggleWishlist(ProductModel product) {
    if (isProductInWishlist(product)) {
      _wishlist.removeWhere((p) => _isSameProduct(p, product));
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
          _isSameProduct(item.product, product) &&
          item.size == size &&
          item.color == color,
    );
    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      _cartItems.add(
        CartItem(product: product, size: size, color: color, quantity: 1),
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

  double get deliveryCharge => 0.0;

  double get totalPayment => subtotal + deliveryCharge;

  int get totalItemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
