import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/products_model.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductsModel> _wishlist = [];

  List<ProductsModel> get wishlist => _wishlist;

  WishlistProvider() {
    _loadWishlist();
  }

  bool isInWishlist(ProductsModel product) {
    return _wishlist.any((item) => item.id == product.id);
  }


  void addToWishlist(ProductsModel product) {
    _wishlist.add(product);
    notifyListeners();
    _saveWishlist();
  }


  void removeFromWishlist(ProductsModel product) {
    _wishlist.removeWhere((item) => item.id == product.id);
    notifyListeners();
    _saveWishlist();
  }


  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistJson =
    _wishlist.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('wishlist', wishlistJson);
  }


  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? wishlistJson = prefs.getStringList('wishlist');
    if (wishlistJson != null) {
      _wishlist = wishlistJson
          .map((item) => ProductsModel.fromJson(jsonDecode(item)))
          .toList();
      notifyListeners();
    }
  }
}
