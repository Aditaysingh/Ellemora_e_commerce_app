import 'package:e_commerce_app/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import '../main.dart';

class CartProvider with ChangeNotifier {
  List<ProductsModel> _cartItems = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;

  List<ProductsModel> get cartItems => _cartItems;

  CartProvider() {
    loadCartData();
  }

  Future<void> addToCart(ProductsModel product) async {
    _cartItems.add(product);
    notifyListeners();
    await saveCartData();
    await showNotification(product);
  }

  Future<void> removeFromCart(ProductsModel product) async {
    _cartItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
    await saveCartData();
  }

  Future<void> saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _cartItems.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('cartData', cartData);
  }

  Future<void> loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cartData');
    if (cartData != null) {
      _cartItems = cartData.map((item) => ProductsModel.fromJson(json.decode(item))).toList();
      notifyListeners();
    }
  }


  Future<void> showNotification(ProductsModel product) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'cart_channel',
      'Cart Notifications',
      channelDescription: 'Notifications for items added to the cart',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Added to Cart',
      '${product.title} has been added to your cart!',
      platformChannelSpecifics,
    );
  }

  int get cartItemCount => _cartItems.length;
}
