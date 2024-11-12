import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/add_cart_provider.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('My Cart',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('No items in the cart'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (ctx, index) {
          final item = cartItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network(
                item.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item.title!),
              subtitle: Text('\$${item.price}'),
              trailing: IconButton(
                icon: Icon(Icons.remove_shopping_cart),
                onPressed: () {
                  cartProvider.removeFromCart(item);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
