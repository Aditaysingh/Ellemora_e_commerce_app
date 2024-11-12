import 'package:e_commerce_app/views/auth_screen.dart';
import 'package:e_commerce_app/views/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/products_provider.dart';
import '../controllers/theme_provider.dart';
import '../controllers/auth_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    } catch (error) {
      print("Failed to load products: $error");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    Provider.of<ProductProvider>(context, listen: false).searchProducts(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(color: Colors.black),
        )
            : const Text('Product List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  Provider.of<ProductProvider>(context, listen: false).searchProducts('');
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                authProvider.isAuthenticated && authProvider.userName != null
                    ? authProvider.userName!
                    : 'Guest',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              accountEmail: Text(
                authProvider.isAuthenticated ? 'Logged in' : 'Not logged in',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: isDarkMode ? Colors.white : Colors.black,
                child: authProvider.isAuthenticated && authProvider.userName != null
                    ? Text(
                  authProvider.userName![0].toUpperCase(),
                  style: const TextStyle(color: Colors.blue, fontSize: 20),
                )
                    : Icon(Icons.account_circle,
                    color: isDarkMode ? Colors.black : Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_6, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Toggle Theme',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                themeProvider.toggleTheme(!isDarkMode);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Logout',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () async {
                await authProvider.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen(),));
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ProductItem(product: products[i]),
      ),
    );
  }
}
