import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  Future<String?> _loginWithEmailOrUsername(String input, String password, AuthService authService) async {
    String email = input.trim();
    // Verifică dacă inputul este email
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      // Dacă nu e email, caută email-ul asociat username-ului
      final res = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: email)
          .limit(1)
          .get();
      if (res.docs.isEmpty) {
        return "Username not found";
      }
      email = res.docs.first['email'];
    }
    return await authService.login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10231c),
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
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/gohunt_logo.png',
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                // Username/email
                Text(
                  'Username or Email',
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
                    hintText: 'Enter your username or email',
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
                // Password
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF8ecdb7),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
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
                // Login button
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
                    onPressed: () async {
                      final authService = Provider.of<AuthService>(context, listen: false);
                      final error = await _loginWithEmailOrUsername(
                        emailController.text,
                        passwordController.text,
                        authService,
                      );
                      if (!mounted) return;
                      if (error != null) {
                        setState(() {
                          errorMessage = error;
                        });
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen(clues: [])),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 12),
                // Google Sign-In button
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
                      'Sign in with Google',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      final authService = Provider.of<AuthService>(context, listen: false);
                      final error = await authService.signInWithGoogle();
                      if (!mounted) return;
                      if (error != null) {
                        setState(() {
                          errorMessage = error;
                        });
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen(clues: [])),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Register link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
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
// This screen allows users to log in with their email and password.
// It uses the AuthService to handle authentication and displays error messages if login fails.