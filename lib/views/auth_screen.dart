import 'package:e_commerce_app/views/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool isLogin = true;

  Future<void> _authenticate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (isLogin) {
        await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        Fluttertoast.showToast(
          msg: "Successfully logged in!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
        );
      } else {
        await authProvider.signup(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _phoneController.text.trim(),
        );
        Fluttertoast.showToast(
          msg: "Account created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Authentication Error: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth > 600 ? 400 : screenWidth * 0.9,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLogin ? 'Login Page' : 'Sign Up Page',
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenWidth * 0.05),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15.0),
              child: const Column(
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  Text(
                    "To",
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  Text(
                    "Ellemora",
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
            if (!isLogin)
              Column(
                children: [
                  _buildTextField(
                    labelText: 'Name',
                    icon: Icons.person,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    labelText: 'Phone Number',
                    icon: Icons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            _buildTextField(
              labelText: 'Email',
              icon: Icons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              labelText: 'Password',
              icon: Icons.lock,
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: screenWidth > 600 ? 400 : screenWidth * 0.9,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _authenticate,
                child: Text(
                  isLogin ? 'Login' : 'Sign Up',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin
                      ? 'Don\'t have an account?'
                      : 'Already have an account?',
                  style: TextStyle(fontSize: screenWidth > 600 ? 18 : 16),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin ? 'Sign Up' : 'Login',
                    style: TextStyle(fontSize: screenWidth > 600 ? 18 : 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
