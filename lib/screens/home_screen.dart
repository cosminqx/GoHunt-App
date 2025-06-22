import 'package:flutter/material.dart';
import '../models/clue.dart';

class HomeScreen extends StatelessWidget {
  final List<Clue> clues;

  const HomeScreen({super.key, required this.clues});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoHunt')),
      body: ListView.builder(
        itemCount: clues.length,
        itemBuilder: (context, index) {
          final clue = clues[index];
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(clue.title),
            subtitle: Text(clue.description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navighează la pagina de scanare QR
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
