// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/stats.dart';
import 'package:flutter_rpg/models/vocation.dart';
import 'package:flutter_rpg/models/skill.dart';


class Character with Stats {

  // constructors 
  Character({
    required this.name,
    required this.slogan,
    required this.vocation,
    required this.backstory,
    required this.id,
  });

  // fields
  final Set<Skill> skills = {};
  final Vocation vocation;
  final String name;
  final String slogan;
  final String backstory;
  final String id;
  bool _isFav = false;

  // getters 
  bool get isFav => _isFav;

  void toggleIsFav() {
    _isFav = !_isFav;
  }

  void updateSkill(Skill skill) {
    skills.clear();
    skills.add(skill);
  }

  Map<String, dynamic> toFirestore() {
    // needs to return a map 
    return {
      'name': name,
      'slogan': slogan,
      'isFav': _isFav,
      'vocation': vocation.toString(), //looks like: vocation.ninja
      'backstory': backstory,
      'skills': skills.map((s)=> s.id).toList(),
      'stats': statsAsMap,
      'points': points,
    }; 
  }

  factory Character.fromFirestore(
    // DocumentSnapshot: firestore sends back when we fetch data 
    // represents snapshot of a document/snapshot of it at that moment in time, contains info about it & data
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    // object SnapshotOptions: also from firestore sdk
    // contains any options about how the data get retrieved
    SnapshotOptions? options

  ) {
    // get data from snapshot
    final data = snapshot.data()!; 
    
    // make a character instance
    Character character = Character(
      name: data['name'],
      slogan: data['slogan'],
      backstory: data['backstory'],
      id: snapshot.id, 
      vocation: Vocation.values.firstWhere((element) => element.toString() == data['vocation']),
    );
    
    for (String id in data['skills']) {
      Skill skill = allSkills.firstWhere((element) => element.id == id);
      character.updateSkill(skill);
    }

    if (data['isFav'] == true) {
      character.toggleIsFav();
    }

    character.setStats(
      points: data['points'],
      stats: data['stats'],
    );

    return character;
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      name: map['name'],
      slogan: map['slogan'],
      vocation: Vocation.values.firstWhere((v) => v.toString() == map['vocation']),
      backstory: map['backstory'],
      id: map['id'],
    );
    // ..skills.addAll(map['skills'].map((skillId) => allSkills.firstWhere((skill) => skill.id == skillId)))
    // ..setStats(
    //   points: map['points'],
    //   stats: map['stats'],
    // )
    // .._isFav = map['isFav'] ?? false;
  }

  Map<String, dynamic> toMap() {
    // needs to return a map 
    return {
      'name': name,
      'slogan': slogan,
      'vocation': vocation.toString(), //looks like: vocation.ninja
      'backstory': backstory,
      'id': id
    }; 
  }
}



// dummy character data 
// List<Character> characters = [
//   Character(id: '1', name: 'Klara', vocation: Vocation.wizard, slogan: 'Kapumf!'),
//   Character(id: '2', name: 'Jonny', vocation: Vocation.junkie, slogan: 'Light me up...'),
//   Character(id: '3', name: 'Crimson', vocation: Vocation.raider, slogan: 'Fire in the hole!'),
//   Character(id: '4', name: 'Shaun', vocation: Vocation.ninja, slogan: 'Alright then gang.'),
// ];