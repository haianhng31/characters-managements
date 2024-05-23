// import 'package:flutter/material.dart';
// import 'package:flutter_rpg/models/character.dart';
// import 'package:flutter_rpg/screens/map/marker_window.dart';
// import 'package:flutter_rpg/services/firestore_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class MarkerWindowWrapper extends StatefulWidget {
//   final String characterId;
//   final List<String> characterIdsAssociated;
//   final String date;
//   final String description;

//   const MarkerWindowWrapper({
//     Key? key,
//     required this.characterId,
//     required this.characterIdsAssociated,
//     required this.date,
//     required this.description,
//   }) : super(key: key);

//   @override
//   _MarkerWindowWrapperState createState() => _MarkerWindowWrapperState();
// }

// class _MarkerWindowWrapperState extends State<MarkerWindowWrapper> {
//   Character? character;
//   List<String>? charactersAssociatedImages;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     character = await fetchCharacter(widget.characterId);
//     charactersAssociatedImages = await fetchCharactersAssociated(widget.characterIdsAssociated);
//     setState(() {});
//   }

//   Future<Character> fetchCharacter(characterId) async {
//     DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(characterId);
//     Character character = snapshot.data()!;
//     // print("Character is fetched from Firestore: ${character.name}");
//     return character;
//   }

//   Future<List<String>> fetchCharactersAssociated (characterIdsAssociated) async {
//     // print("fetchCharactersAssociated started.");
//     List<String> images = [];
//     for (var id in characterIdsAssociated) {
//       DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(id);
//       Character characterAssociated = snapshot.data()!;
//       // print("characterAssociated img: ${characterAssociated.vocation.image}");
//       images.add('assets/img/vocations/${characterAssociated.vocation.image}');
//     }
//     // print("fetchCharactersAssociated result: $images");
//     return images;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (character == null || charactersAssociatedImages == null) {
//       return const CircularProgressIndicator();
//     }

//     return MarkerWindow(
//       character: character!,
//       date: widget.date,
//       charactersAssociated: charactersAssociatedImages!,
//       description: widget.description,
//     );
//   }
// }