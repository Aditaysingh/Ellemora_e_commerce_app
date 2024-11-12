import 'package:badges/badges.dart';
import 'package:e_commerce_app/model/products_model.dart';
import 'package:e_commerce_app/views/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/add_cart_provider.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailScreen extends StatelessWidget {
  final ProductsModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          badges.Badge(
            badgeContent: Text(
              cartProvider.cartItemCount.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            position: BadgePosition.topEnd(top: 0, end: 3),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
        ],
        title: Text(
          product.title!,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    product.image!,
                    height: screenHeight * 0.4,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title!,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          product.description!,
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      cartProvider.addToCart(product);
                      cartProvider.showNotification(product);
                    },
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () {},
                    child: Text(
                      'Buy',
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
