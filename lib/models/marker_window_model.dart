import 'package:cloud_firestore/cloud_firestore.dart';

class MarkerWindowModel {
  // constructor
  MarkerWindowModel({
    required this.characterId,
    required this.date,
    required this.lat,
    required this.lng,
    required this.characterIdsAssociated,
    required this.description,
    required this.markerImg,
    required this.id
  });

  // fields 
  final String characterId;
  final String date;
  final double lat;
  final double lng;
  final List<String> characterIdsAssociated;
  final String description;
  final String markerImg;
  final String id;
  // Character? character;

  // Future<Character> _getCharacterInfo(String characterId) async {
  //   DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(characterId);
  //   character = Character.fromFirestore(snapshot.data()!);
  //   return character!;
  // }

  // getters 
  Map<String, dynamic> get markerWindowInfo => {
    "characterId": characterId,
    "date": date,
    "lat": lat,
    "lng": lng,
    // "characterIdsAssociated": characterIdsAssociated.map((char) => char.toFirestore()).toList(),
    "characterIdsAssociated": characterIdsAssociated,
    "description": description,
    "markerImg": markerImg
  };

  Map<String, dynamic> toFirestore() => {
    // "character": character.toFirestore(),
    "characterId": characterId,
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
      characterId: data['characterId'], 
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