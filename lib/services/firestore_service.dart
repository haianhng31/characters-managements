import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/character.dart';

class FirestoreService {
  // Make a reference object - Like a table in SQL 
  // static: we can access this directly on the firestoreService class anywhere from the app without creating a new instance
  static final ref = FirebaseFirestore.instance
    .collection('characters')
    .withConverter(
      fromFirestore: Character.fromFirestore,
      toFirestore: (Character c, _) => c.toFirestore() 
    );


  // Add a new character to the database
  static Future<void> addCharacter(Character character) async {
    await ref.doc(character.id).set(character);
  }

  // get characters from the database
  static Future<QuerySnapshot<Character>> getCharactersOnce(){
    return ref.get();
  }

  // get one Character 
  static Future<DocumentSnapshot<Character>> getCharacter(String id) {
    return ref.doc(id).get();
  }

  // update a character 
  static Future<void> updateCharacter(Character character) async {
    await ref.doc(character.id).update({
      'stats': character.statsAsMap,
      'points': character.points,
      'skills': character.skills.map((s) => s.id).toList(),
      'isFav': character.isFav,
    });
  }

  // delete a character
  static Future<void> deleteCharacter(Character character) async {
    await ref.doc(character.id).delete();
  }
}