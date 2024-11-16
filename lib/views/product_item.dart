import 'package:e_commerce_app/model/products_model.dart';
import 'package:e_commerce_app/views/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/wishlist_provider.dart';

class ProductItem extends StatelessWidget {
  final ProductsModel product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isInWishlist = wishlistProvider.isInWishlist(product);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.4,
                    child: Image.network(
                      product.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Wishlist Icon
                  Positioned(
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.02,
                    child: IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.grey,
                        size: screenWidth * 0.06,
                      ),
                      onPressed: () {
                        if (isInWishlist) {
                          wishlistProvider.removeFromWishlist(product);
                        } else {
                          wishlistProvider.addToWishlist(product);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Product Title
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Text(
                product.title!,
                style: TextStyle(
                  fontSize: screenWidth * 0.030,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Product Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Text(
                '\$${product.price.toString()}',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            ),
            SizedBox(height: screenHeight * 0.008),
            // Ratings Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: screenWidth * 0.05,
                ),
                SizedBox(width: screenWidth * 0.008),
                Text(
                  product.rating?.rate?.toStringAsFixed(1) ?? "N/A",
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                SizedBox(width: screenWidth * 0.008),
                Text(
                  "(${product.rating?.count ?? 0})",
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
