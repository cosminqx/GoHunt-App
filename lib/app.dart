import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/clue_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/user_info_screen.dart';
class GoHuntApp extends StatelessWidget {
  const GoHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'GoHunt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: user == null ? '/login' : '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => Consumer<ClueProvider>(
              builder: (context, clueProvider, _) {
                return HomeScreen(clues: clueProvider.clues);
              },
            ),
        '/profile': (context) => const UserInfoScreen(),
        // ...alte rute
      },
    );
  }
}
