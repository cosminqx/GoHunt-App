import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  AuthService() {
    _auth.authStateChanges().listen((User? newUser) {
      user = newUser;
      notifyListeners();
    });
  }

  bool get isLoggedIn => user != null;

  // Register with email, password, fullName, username
  Future<String?> register(String email, String password, String fullName, String username) async {
    try {
      // Verifică unicitatea username-ului
      final usernameExists = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (usernameExists.docs.isNotEmpty) {
        return 'Username already taken';
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Salvează datele suplimentare în Firestore
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email,
        'fullName': fullName,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'email',
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Google Sign-In cu generare username automat
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Sign in aborted by user';
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential cred = await _auth.signInWithCredential(credential);

      // Verifică dacă user-ul există deja în Firestore
      final userDoc = await _firestore.collection('users').doc(cred.user!.uid).get();
      if (!userDoc.exists) {
        // Generează username unic
        String base = (cred.user!.displayName ?? "user").toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        String username = base;
        bool exists = true;
        while (exists) {
          final res = await _firestore.collection('users').where('username', isEqualTo: username).get();
          if (res.docs.isEmpty) {
            exists = false;
          } else {
            String randomDigits = (Random().nextInt(9000) + 1000).toString();
            username = "$base$randomDigits";
          }
        }
        // Salvează datele în Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': cred.user!.email,
          'fullName': cred.user!.displayName ?? '',
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
          'provider': 'google',
        });
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
// This class handles user authentication using Firebase Auth.
// It listens for authentication state changes and notifies listeners when the user state changes