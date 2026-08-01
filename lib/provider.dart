import 'package:flutter/material.dart';
import 'package:original_stock/screens/home_screen.dart';

class ProviderProduct extends ChangeNotifier {
  ProductModel? selectedProduct;

  void selectedproduct(ProductModel? product) {
    selectedProduct = product;
    notifyListeners();
  }
}
