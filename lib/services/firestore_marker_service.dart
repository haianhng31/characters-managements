import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/marker_window_model.dart';

class FirestoreMarkerService {
  // Make a reference object - Like a table in SQL 
  // static: we can access this directly on the firestoreService class anywhere from the app without creating a new instance
  static final ref = FirebaseFirestore.instance
    .collection('markers')
    .withConverter(
      fromFirestore: MarkerWindowModel.fromFirestore,
      toFirestore: (MarkerWindowModel m, _) => m.toFirestore() 
    );

  // Add a new marker 
  static Future<void> addMarker(MarkerWindowModel marker) async {
    await ref.doc(marker.id).set(marker);
  }

  // Get all markers 
  static Future<QuerySnapshot<MarkerWindowModel>> getAllMarkers() async {
    return await ref.get();
  }

  // get one Marker 
  static Future<DocumentSnapshot<MarkerWindowModel>> getMarker(String id) {
    return ref.doc(id).get();
  }

  // update a Marker 
  static Future<void> updateMarker(MarkerWindowModel marker) async {
    await ref.doc(marker.id).update({
      "characterId": marker.characterId,
      "date": marker.date,
      "lat": marker.lat,
      "lng": marker.lng,
      "characterIdsAssociated": marker.characterIdsAssociated,
      "description": marker.description,
      "markerImg": marker.markerImg
      });
  }

  // delete a Marker
  static Future<void> deleteMarker(MarkerWindowModel marker) async {
    await ref.doc(marker.id).delete();
  }
  
}