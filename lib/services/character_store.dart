import 'package:flutter/material.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:flutter_rpg/services/firestore_service.dart';

// when make changes, notify the listeners of the data
class CharacterStore extends ChangeNotifier {
  final List<Character> _characters = []; 

  get characters => _characters;

  void addCharacter(Character character) {
    try {
      FirestoreService.addCharacter(character);
      _characters.add(character);
      notifyListeners();
      // notify any consumers in the app that we have changed it 
      // the consumer can rerun the app to see the changes
    } catch (e) {
      print('Error adding character: $e');
    }
    
  }

  void fetchCharactersOnce() async {
    if (_characters.isEmpty) {
      final snapshot = await FirestoreService.getCharactersOnce();
      for (var doc in snapshot.docs) {
        _characters.add(doc.data());
      }
      notifyListeners();
    }
  }

  // save / update a character
  Future<void> saveCharacter(Character character) async {
    await FirestoreService.updateCharacter(character);
    return;
  }

  // delete a character
  void removeCharacter(Character character) async {
    await FirestoreService.deleteCharacter(character);
    _characters.remove(character);
    notifyListeners();
  }
}