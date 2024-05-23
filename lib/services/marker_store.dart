import 'package:flutter/material.dart';
import 'package:flutter_rpg/models/marker.dart';
import 'package:flutter_rpg/services/marker_service.dart';


class MarkerStore extends ChangeNotifier {
  final List<MarkerWindowModel> _markers = [];

  get markers => _markers;

  void addMarker(MarkerWindowModel marker) {
    FirestoreMarkerService.addMarker(marker);
    _markers.add(marker);
    notifyListeners();
  }

  void fetchMarkersOnce() async {
    if (_markers.isEmpty) {
      try {
        final snapshot = await FirestoreMarkerService.getAllMarkers();
        for (var doc in snapshot.docs) {
          _markers.add(doc.data());
        }
        notifyListeners();
      } catch (e) {
        // Handle any errors here
        print("Error fetching all markers: $e");
      }
    }
  }

  // Future<void> saveMarker(MarkerWindowModel marker) async {
  //   await FirestoreMarkerService.updateMarker(marker);
  //   notifyListeners();
  //   return;
  // }

  Future<void> removeMarker(MarkerWindowModel marker) async {
    await FirestoreMarkerService.deleteMarker(marker);
    _markers.remove(marker);
    notifyListeners();
    return;
  }
 
}