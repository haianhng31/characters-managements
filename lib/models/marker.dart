import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/character.dart';

class MarkerWindowModel {
  // constructor
  MarkerWindowModel({
    // required this.characterId,
    required this.character,
    required this.date,
    required this.lat,
    required this.lng,
    required this.characterIdsAssociated,
    // required this.charactersAssociated,
    required this.description,
    required this.markerImg,
    required this.id
  });

  // fields 
  // final String characterId;
  final Character character;
  final String date;
  final double lat;
  final double lng;
  final List<String> characterIdsAssociated;
  // final List<Character> charactersAssociated;
  final String description;
  final String markerImg;
  final String id;

  // getters 
  Map<String, dynamic> get markerWindowInfo => {
    // "characterId": characterId,
    'character': character.toFirestore(),
    "date": date,
    "lat": lat,
    "lng": lng,
    // "characterIdsAssociated": characterIdsAssociated.map((char) => char.toFirestore()).toList(),
    "characterIdsAssociated": characterIdsAssociated,
    "description": description,
    "markerImg": markerImg
  };

  Map<String, dynamic> toFirestore() => {
    // "characterId": characterId,
    "character": character.toFirestore(),
    "date": date, 
    "lat": lat,
    "lng": lng,
    "characterIdsAssociated": characterIdsAssociated,
    "description": description,
    "markerImg": markerImg
  };

  factory MarkerWindowModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;

    MarkerWindowModel marker = MarkerWindowModel(
      // characterId: data['characterId'], 
      character: Character.fromMap(data['character']),
      date: data['date'], 
      lat: data['lat'],
      lng: data['lng'], 
      characterIdsAssociated: List<String>.from(data['characterIdsAssociated']),
      description: data['description'], 
      markerImg: data['markerImg'],
      id: snapshot.id
    );

    return marker;
  }


}