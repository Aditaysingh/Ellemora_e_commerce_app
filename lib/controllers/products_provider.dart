import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/products_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductsModel> _products = [];
  List<ProductsModel> _filteredProducts = [];

  List<ProductsModel> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;

  Future<void> fetchProducts() async {
    const url = 'https://fakestoreapi.com/products';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        _products = data.map((item) => ProductsModel.fromJson(item)).toList();
        _filteredProducts = _products;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products.where((product) {
        return product.title!.toLowerCase().contains(query.toLowerCase().trim());
      }).toList();
    }
    notifyListeners();
  }
}

