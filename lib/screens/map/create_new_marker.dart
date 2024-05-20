import 'package:flutter/material.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:flutter_rpg/models/marker_window_model.dart';
import 'package:flutter_rpg/services/character_store.dart';
import 'package:flutter_rpg/services/marker_store.dart';
// import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:custom_info_window/custom_info_window.dart';

var uuid = const Uuid();

class CreateMarkerWindow extends StatefulWidget {
  const CreateMarkerWindow({
    super.key, 
    required this.pos,
    required this.controller,
    required this.updateMarkers,
  });

  final LatLng pos;
  final CustomInfoWindowController controller;
  final void Function() updateMarkers;

  @override
  State<CreateMarkerWindow> createState() => _CreateMarkerWindowState();
}

class _CreateMarkerWindowState extends State<CreateMarkerWindow> {
  late final CustomInfoWindowController _controller;
  final _formKey = GlobalKey<FormState>();
  late final Map<String, List<String>> _allCharacters = {};
  String? _selectedCharacter; 
  DateTime? _selectedDate;
  String _description = '';
  Map<String, bool> _characterChecked = {'0a7eb94a-9296-48d1-a0d4-b0de37b092f2': true, 'a6043e36-9c80-42ca-898f-290813087ab6': false, 'c8292c15-6fc7-4cc2-ba3d-a94e5b724371': false};
  late List<String> _selectedCharacterAssociated;
  bool dataInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeAllCharacters();
    _controller = widget.controller;
    _selectedCharacterAssociated = _characterChecked.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
  }

  Future<void> initializeAllCharacters() async {
    List<Character> storeCharacters = Provider.of<CharacterStore>(context, listen: false).characters;
    for (Character character in storeCharacters) {
      _allCharacters[character.id] = [character.name, 'assets/img/vocations/${character.vocation.image}'];
    }
    setState(() {
      dataInitialized = true;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

  @override
  Widget build(BuildContext context) {

    return (dataInitialized==false) ? Center(child: CircularProgressIndicator()) : Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField(
                        value: _selectedCharacter,
                        items: _allCharacters.entries.map((character) {
                          return DropdownMenuItem<String>(
                            value: character.key,
                            child: Row(
                              children: [
                                ClipOval( child: Image.asset(
                                  character.value[1],
                                  fit: BoxFit.cover,
                                  width: 25, 
                                  height: 25
                                  )
                                ),
                                const SizedBox(width: 10,),
                                Text(character.value[0]),
                              ],)
                          );
                        }).toList(),
                        hint: Text("Select a character"),
                        onChanged: (value) {
                          setState(() {
                            _selectedCharacter = value;
                          });
                        },
                      ),
                
                      const SizedBox(height: 3,),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Select a date'}'),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Select'),
                          ),
                        ],
                      ),
              
                      const SizedBox(height: 3,),
              
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            _description = value;
                          });
                        },
                      ),
              
                      const SizedBox(height: 3,),

                      Wrap(
                        spacing: 1.5,
                        children: _selectedCharacterAssociated.isEmpty ? [const Center(child: Text("Currently empty..."))] : 
                          _selectedCharacterAssociated.map((character) => Chip(
                            label: Text(character),
                            onDeleted: () {
                              setState(() {
                                _characterChecked[character] = false;
                                _selectedCharacterAssociated = _characterChecked.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
                              });
                            })).toList(),
                      ),

                      const SizedBox(height: 3.0),
              
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final newMarker = MarkerWindowModel(
                                characterId: _selectedCharacter!,
                                date: DateFormat('yyyy-MM-dd').format(_selectedDate!), 
                                lat: widget.pos.latitude,
                                lng: widget.pos.longitude,
                                characterIdsAssociated: _selectedCharacterAssociated,
                                description: _description,
                                markerImg: _allCharacters[_selectedCharacter]![1],
                                id: uuid.v4()
                              );
                              Provider.of<MarkerStore>(context, listen: false).addMarker(newMarker);
                              _controller.hideInfoWindow!();
                              widget.updateMarkers();
                            }}, 
                          child: const Text('Submit')),
                      ),
                    ],
                  )),
              ),
            ),
          ),
        ),
        
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Colors.white,
            width: 20.0,
            height: 10.0,
          ),
        ),
      ],
    );
  }
}