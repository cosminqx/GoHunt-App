import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/clue_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoHuntApp extends StatelessWidget {
  const GoHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'GoHunt',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: user != null
          ? Consumer<ClueProvider>(
              builder: (context, clueProvider, _) {
                return HomeScreen(clues: clueProvider.clues);
              },
            )
          : const LoginScreen(),
    );
  }
}
