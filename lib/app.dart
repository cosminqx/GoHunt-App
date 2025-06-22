import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/clue_provider.dart';
import 'auth_service.dart';

class GoHuntApp extends StatelessWidget {
  const GoHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return MaterialApp(
      title: 'GoHunt',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: authService.isLoggedIn
          ? Consumer<ClueProvider>(
              builder: (context, clueProvider, _) {
                return HomeScreen(clues: clueProvider.clues);
              },
            )
          : const LoginScreen(),
    );
  }
}
