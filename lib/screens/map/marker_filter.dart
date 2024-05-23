import 'package:flutter/material.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:flutter_rpg/services/character_store.dart';
import 'package:provider/provider.dart';

class MarkerFilter extends StatefulWidget {
  const MarkerFilter({
    super.key,
    required this.onCharacterSelected,
  });

  final Function(String) onCharacterSelected;

  @override
  State<MarkerFilter> createState() => _MarkerFilterState();
}

class _MarkerFilterState extends State<MarkerFilter> {
  String? _selectedCharacterId;
  late final Map<String, Character> _allCharacters = {};
  bool dataInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeAllCharacters();
  }

  Future<void> initializeAllCharacters() async {
    List<Character> storeCharacters = Provider.of<CharacterStore>(context, listen: false).characters;
    for (Character character in storeCharacters) {
      _allCharacters[character.id] = character;
    }
    setState(() {
      dataInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (dataInitialized==false) ? const Center(child: CircularProgressIndicator()) : 
    DropdownButton<String>(
      value: _selectedCharacterId,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCharacterId = newValue;
        });
        widget.onCharacterSelected(newValue!);
      },
      items: [
        const DropdownMenuItem(
          value: "",
          child: Text('Show all'),
        ),
        ..._allCharacters.entries.map((character) {
          return DropdownMenuItem(
            value: character.key,
            child: Text(character.value.name),
          );
        }),
      ],
    );
  }
}
