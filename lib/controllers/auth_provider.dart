import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _userName;
  User? get user => _user;
  String? get userName => _userName;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _fetchUserData();
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        final doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          _userName = doc['name'];
        }
        notifyListeners();
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      await _fetchUserData();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;

      await _firestore.collection('users').doc(_user!.uid).set({
        'name': name,
        'phone': phone,
        'email': email,
      });

      _userName = name;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _userName = null;
    notifyListeners();
  }
}
