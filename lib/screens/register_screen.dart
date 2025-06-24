import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  Future<void> _registerWithEmail(AuthService authService) async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match!";
        isLoading = false;
      });
      return;
    }
    final error = await authService.register(
      emailController.text.trim(),
      passwordController.text.trim(),
      fullNameController.text.trim(),
      usernameController.text.trim(),
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        errorMessage = error;
        isLoading = false;
      });
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(clues: []),
      ),
    );
  }

  Future<void> _registerWithGoogle(AuthService authService) async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    final result = await authService.signInWithGoogle();
    if (!mounted) return;
    if (result != null) {
      setState(() {
        errorMessage = result;
        isLoading = false;
      });
      return;
    }
    // După sign-in, verifică dacă există username, altfel generează unul și salvează datele suplimentare
    final user = authService.user;
    if (user == null) {
      setState(() {
        errorMessage = "Google sign-in failed!";
        isLoading = false;
      });
      return;
    }
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      // Generează username unic
      String base = (user.displayName ?? "user").toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      String username = base;
      bool exists = true;
      while (exists) {
        final res = await firestore.collection('users').where('username', isEqualTo: username).get();
        if (res.docs.isEmpty) {
          exists = false;
        } else {
          String randomDigits = (Random().nextInt(9000) + 1000).toString();
          username = "$base$randomDigits";
        }
      }
      // Salvează datele suplimentare în Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'fullName': user.displayName ?? '',
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'google',
      });
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(clues: []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF10231c),
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF10231c),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner imagine
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuC3ZOQuxR1rZiCIKeJUiNpY26L7UY5xVGJYD86NbULNEW82byUU5C0Px6dyXZnkhKkUzD_hwkcHLSY_2YtNSMSd2jDa8bGOagjx1utXYWdhmXG2PAcAw3rUijkaG08JU7A2ZE6byPjSDP_NiD7K93smZfFuEyUGhmx2grWygXhDJaMNRAjbR27ZIoITm8FXP8V-5Gxe6cdEoVMD3K-OHwILZuVwCJjMLzZJy2FGiFFOPdTnLdFi06rRn_D6BipiZLZPlCS_vvkATKQ',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Full Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: fullNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: const TextStyle(color: Color(0xFF8ecdb7)),
                    filled: true,
                    fillColor: const Color(0xFF17352b),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Choose a username',
                    hintStyle: const TextStyle(color: Color(0xFF8ecdb7)),
                    filled: true,
                    fillColor: const Color(0xFF17352b),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Color(0xFF8ecdb7)),
                    filled: true,
                    fillColor: const Color(0xFF17352b),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Color(0xFF8ecdb7)),
                    filled: true,
                    fillColor: const Color(0xFF17352b),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Confirm Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: const TextStyle(color: Color(0xFF8ecdb7)),
                    filled: true,
                    fillColor: const Color(0xFF17352b),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2f6a55)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF019863),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.015,
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            await _registerWithEmail(authService);
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register'),
                  ),
                ),
                const SizedBox(height: 16),
                // Register with Google button
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.015,
                      ),
                    ),
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      'Register with Google',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            await _registerWithGoogle(authService);
                          },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Color(0xFF8ecdb7),
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}