import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:flutter_rpg/models/character.dart';
// import 'package:flutter_rpg/services/character_store.dart';
import 'package:flutter_rpg/services/firestore_service.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
// import 'package:provider/provider.dart';

class MarkerWindow extends StatefulWidget {
  const MarkerWindow({
    super.key,
    required this.characterId,
    required this.date,
    required this.characterIdsAssociated,
    required this.description,
  });

  final String characterId;
  final String date;
  final List<String> characterIdsAssociated;
  final String description;

  @override
  State<MarkerWindow> createState() => _MarkerWindowState();
}

class _MarkerWindowState extends State<MarkerWindow> {
  late final String characterName;
  late final String characterImg;
  late final List<String> charactersAssociated;
  bool isLoading = true;

  void fetchCharacters() async {
    DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(widget.characterId);
    Character character = snapshot.data()!;

    List<String> images = await Future.wait(widget.characterIdsAssociated.map((id) async {
      DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(id);
      Character characterAssociated = snapshot.data()!;
      return 'assets/img/vocations/${characterAssociated.vocation.image}';
    }).toList());

    print("Character is fetched from Firestore: ${character.name}");

    setState(() {
      charactersAssociated = images;
      characterName = character.name;
      characterImg = 'assets/img/vocations/${character.vocation.image}';
      isLoading = false; 
    });
  }

  @override
  void initState() {
    fetchCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: isLoading ? [const Center(child: CircularProgressIndicator())] : 
      [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval( child: Image.asset(
                        characterImg,
                        fit: BoxFit.cover,
                        width: 30, 
                        height: 30
                        )
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledHeading(characterName),
                          StyledText(widget.date)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 1.0),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(widget.description),
                      ],
                    ),
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: 
                      charactersAssociated.map((img) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ClipOval( child: Image.asset(
                          img,
                          fit: BoxFit.cover,
                          width: 18, 
                          height: 18
                          )
                        ),
                      )).toList()
                  ),
                ],
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