// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rpg/models/app_user.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<AppUser?> signUp(String email, String password) async {
    try {
      // check if email is already in use

      // check if username is already in use
      // final querySnapshot = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get();
      // if (querySnapshot.docs.isNotEmpty) {
      //   throw "Username already in use";
      // }

      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return AppUser(
            uid: credential.user!.uid,
            email: credential.user!.email!,
        );
      }
      return null;

    } catch (e) {
      print("Cannot create new account: $e");
      return null;
    }
  }
}