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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.network(
                    product.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.grey,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('\$${product.price.toString()}'),
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20,),
                const SizedBox(
                  width: 4,
                ),
                Text(product.rating?.rate?.toStringAsFixed(1) ?? "N/A"),
                SizedBox(
                  width: 4,
                ),
                Text("(${product.rating?.count ?? 0})")
              ],
            )
          ],
        ),
      ),
    );
  }
}
