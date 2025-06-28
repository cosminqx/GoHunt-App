import 'package:flutter/material.dart';
import '../models/clue.dart';

class ClueProvider with ChangeNotifier {
  final List<Clue> _clues = [
    Clue(id: '1', title: 'Primul indiciu', description: 'Găsește statuia din centru'),
    Clue(id: '2', title: 'Al doilea indiciu', description: 'Urmărește arcul de triumf'),
  ];

  List<Clue> get clues => List.unmodifiable(_clues);

  // Pe viitor, metode pentru a adăuga, modifica sau valida indicii
}
