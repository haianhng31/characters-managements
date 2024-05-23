import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rpg/screens/map/create_new_marker.dart';
import 'package:flutter_rpg/screens/map/markerWindowWrapper.dart';
import 'package:flutter_rpg/screens/map/marker_window.dart';
import 'package:flutter_rpg/services/location_service.dart';
import 'package:flutter_rpg/services/marker_store.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; 
import 'package:image/image.dart' as img;
import 'package:flutter_rpg/services/firestore_service.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  LatLng? _currentP;

  bool markersInitialized = false;
  
  late final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  late List<Marker> _storeMarkers;
  late List<Marker> _newMarker = [];
  BitmapDescriptor? _markerIcon;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeMarkers();
    getLocationUpdates();
  }

  Future<void> initializeMarkers() async {
    Provider.of<MarkerStore>(context, listen: false).fetchMarkersOnce();
    await _updateMarkers();
    setState(() {
      markersInitialized = true; // Set the flag to indicate initialization is complete
    });
  }

  void _setMarker(LatLng pos) {
    setState(() {
      // storeMarkers.add(
      _newMarker.add(
        Marker(
          markerId: MarkerId('marker'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CreateMarkerWindow(
                pos: pos, 
                controller: _customInfoWindowController,
                updateMarkers: _updateMarkers,),
              pos
            );
          },
        )
      );
    });
  }

  Future<BitmapDescriptor> _loadMarkerIcon(imgPath) async {
    ByteData byteData = await rootBundle.load(imgPath);
    Uint8List bytes = byteData.buffer.asUint8List();

    img.Image baseSizeImage = img.decodeImage(bytes)!;
    img.Image resizedImage = img.copyResize(baseSizeImage, width: 60, height: 60);
    // img.Image circularImage = img.copyCropCircle(resizedImage);
    img.Image circularImage = img.copyCropCircle(resizedImage);

    Uint8List finalImageBytes = Uint8List.fromList(img.encodePng(circularImage));
    _markerIcon = BitmapDescriptor.fromBytes(finalImageBytes);
    return _markerIcon!;
  }

  Future<void> _updateMarkers() async {
    List<Marker> markers = await _fetchMarkers(Provider.of<MarkerStore>(context, listen: false).markers);
    setState(() {
      _storeMarkers = markers;
    });
  }

  Future<List<Marker>> _fetchMarkers(markersData) async {
    List<Marker> markers = [];
    print('fetching markers...');

    for (var marker in markersData) {
      // var character = await fetchCharacter(marker.characterId);
      // var charactersAssociatedImages = await fetchCharactersAssociated(marker.characterIdsAssociated);
      print('marker character name in map: ${marker.character.name}');
      markers.add(Marker(
        markerId: MarkerId(marker.id),
        // icon: _markerIcon!,
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(marker.lat, marker.lng),
        draggable: true,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            MarkerWindow(
              key: marker.id,
              // characterId: marker.characterId,
              character: marker.character,
              date: marker.date,
              characterIdsAssociated: marker.characterIdsAssociated,
              // charactersAssociated: charactersAssociatedImages,
              description: marker.description,
            ),
            LatLng(marker.lat, marker.lng),
          );
        },
      ));
    }
    // }).toList();
    return markers;
  }

  Future<Character> fetchCharacter(characterId) async {
    DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(characterId);
    Character character = snapshot.data()!;
    print("Character is fetched from Firestore: ${character.name}");
    return character;
  }

  // Future<List<String>> fetchCharactersAssociated (characterIdsAssociated) async {
  //   print("fetchCharactersAssociated started.");
  //   List<String> images = [];
  //   for (var id in characterIdsAssociated) {
  //     DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(id);
  //     Character characterAssociated = snapshot.data()!;
  //     print("characterAssociated img: ${characterAssociated.vocation.image}");
  //     images.add('assets/img/vocations/${characterAssociated.vocation.image}');
  //   }
  //   // List<String> images = await Future.wait(characterIdsAssociated.map((id) async {
  //   //   DocumentSnapshot<Character> snapshot = await FirestoreService.getCharacter(id);
  //   //   Character characterAssociated = snapshot.data()!;
  //   //   print("characterAssociated img: ${characterAssociated.vocation.image}");
  //   //   return 'assets/img/vocations/${characterAssociated.vocation.image}';
  //   // }).toList());
  //   print("fetchCharactersAssociated result: $images");
  //   return images;
  // }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle("Map"),
        centerTitle: true,
      ),
      body: (_currentP == null || markersInitialized == false)? const Center(child: CircularProgressIndicator()) : 
        Column(
          children: [
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search location...",
                    hintStyle: TextStyle(color: Colors.white), // Change hint text color to white
                    labelStyle: TextStyle(color: Colors.white), // Change label text color to white
                  ),
                )),
                IconButton(
                  onPressed: () async {
                    var place = await LocationService().getPlace(_searchController.text);
                    _toPlace(place);
                  }, 
                  icon: const Icon(Icons.search))
              ],),

            Expanded(
              child: Stack(
                children: [
                  // Consumer<MarkerStore>(
                  //   builder: (context, value, child) {
                  //     List<Marker> storeMarkers =  Provider.of<MarkerStore>(context, listen: false).markers.map<Marker>((marker) {
                  //       _loadMarkerIcon(marker.markerImg);
                  //       return Marker(
                  //         markerId: MarkerId(marker.id),
                  //         icon: _markerIcon!,
                  //         position: LatLng(marker.lat, marker.lng),
                  //         draggable: true,
                  //         onTap: () {
                  //           _customInfoWindowController.addInfoWindow!(
                  //             MarkerWindow(
                  //               characterId: marker.characterId,
                  //               date: marker.date,
                  //               characterIdsAssociated: marker.characterIdsAssociated,
                  //               description: marker.description,
                  //             ),
                  //             LatLng(marker.lat, marker.lng),
                  //           );
                  //         },
                  //       );
                  //     }).toList();

                      // return 
                      GoogleMap(
                        mapType: MapType.terrain,
                        initialCameraPosition: CameraPosition(
                          target: _currentP!,
                          zoom: 13,),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                          _customInfoWindowController.googleMapController = controller;
                        },
                        onTap: (position) async {
                          _customInfoWindowController.hideInfoWindow!();
                          // var place = await LocationService().getPlaceIdFromLocation(position);
                          _setMarker(position);
                        },
                        onCameraMove: (position) {
                          _customInfoWindowController.onCameraMove!();
                        },
                        markers: {
                          // ...Set<Marker>.of(storeMarkers),
                          ...Set<Marker>.of(_storeMarkers),
                          ..._newMarker,
                          Marker(
                            markerId: const MarkerId("_currentLocation"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                            position: _currentP!,
                            infoWindow: InfoWindow(
                              title: "Current Location",
                              snippet: "${_currentP!.latitude}, ${_currentP!.longitude}",)
                          )
                        },
                        // polylines: Set<Polyline>.of(polylines.values),
                      ),
                  //   }
                  // ),

                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 210,
                    width: 270,
                    offset: 45),
                ],
              ),
            ),
          ],
        ),

      floatingActionButton: 
        FloatingActionButton(
          onPressed: _toCurrentLocation,
          child: const Icon(Icons.my_location_outlined),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled; // flag
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled(); // Checks if the location service is enabled.
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService(); // Request the activation of the location service.
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission(); // Checks if the app has permission to access location.
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission(); // Requests permission to access location.
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // This will Throws an error if the app has no permission to access location.
    _locationController.onLocationChanged.listen((LocationData currentLoc) {
      if (currentLoc.latitude != null && currentLoc.longitude != null) { 
        setState((){
          _currentP = LatLng(currentLoc.latitude!, currentLoc.longitude!);
          // _cameraToPosition(_currentP!);
        });
        // print(_currentP);
      }
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> _toCurrentLocation () async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _currentP!, 
      zoom: 13
    )));
  }

  Future<void> _toPlace (Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng), 
      zoom: 13
    )));

    _setMarker(LatLng(lat, lng));
  }
}