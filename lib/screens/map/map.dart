import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rpg/models/vocation.dart';
import 'package:flutter_rpg/screens/map/create_new_marker.dart';
import 'package:flutter_rpg/screens/map/marker_filter.dart';
import 'package:flutter_rpg/screens/map/marker_window.dart';
import 'package:flutter_rpg/services/location_service.dart';
import 'package:flutter_rpg/services/marker_store.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; 
import 'package:image/image.dart' as img;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  LatLng? _currentP;

  // MARKERS
  bool markersInitialized = false;
  bool currentMarkerInitialized = false;
  late final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  late List<Marker> _storeMarkers;
  final List<Marker> _newMarker = [];
  Map<String, BitmapDescriptor> _allMarkerIcons = {};
  late String _markerFilterCharacter = "";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // initializeMarkers();
    getLocationUpdates();
    initializeCurrentMarkerIcon();
    _loadAllMarkerIcons(); // this is where initializeMarkers() is
    super.initState();
  }

  Future<void> initializeMarkers() async {
    await Provider.of<MarkerStore>(context, listen: false).fetchMarkersOnce();
    _updateMarkers();
    setState(() {
      markersInitialized = true; 
    });
  }

  void _updateMarkers() {
    final markersData = Provider.of<MarkerStore>(context, listen: false).markers;
    final markers =  _fetchMarkers(markersData);
    setState(() {
      _storeMarkers = markers;
    });
  }

  List<Marker> _fetchMarkers(markersData) {
    List<Marker> markers;
    List<PointLatLng> markerPositions = [];
    if (_markerFilterCharacter == "") {
      markers = markersData.map<Marker>((marker) {
        var markerIcon = _allMarkerIcons[marker.character.vocation.toString()];
        markerPositions.add(PointLatLng(marker.lat, marker.lng));
        return Marker(
          markerId: MarkerId(marker.id),
          icon: markerIcon!,
          position: LatLng(marker.lat, marker.lng),
          draggable: true,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              MarkerWindow(
                characterName: marker.character.name,
                characterImg: 'assets/img/vocations/${marker.character.vocation.image}',
                date: marker.date,
                characterIdsAssociated: marker.characterIdsAssociated,
                description: marker.description,
              ),
              LatLng(marker.lat, marker.lng),
            );
          },
        );
      }).toList();
    }
    else {
      markers = markersData.where((marker) => marker.character.id == _markerFilterCharacter).map<Marker>((marker) {
        var markerIcon = _allMarkerIcons[marker.character.vocation.toString()];
        markerPositions.add(PointLatLng(marker.lat, marker.lng));
        return Marker(
          markerId: MarkerId(marker.id),
          icon: markerIcon!,
          position: LatLng(marker.lat, marker.lng),
          draggable: true,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              MarkerWindow(
                characterName: marker.character.name,
                characterImg: 'assets/img/vocations/${marker.character.vocation.image}',
                date: marker.date,
                characterIdsAssociated: marker.characterIdsAssociated,
                description: marker.description,
              ),
              LatLng(marker.lat, marker.lng),
            );
          },
        );
      }).toList();
    } 
    // print(polylines);
    initializePolylinePoints(markerPositions);
    return markers;
  }

  void _setMarker(LatLng pos) {
    setState(() {
      _newMarker.add(
        Marker(
          markerId: MarkerId('marker'),
          position: pos,
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          icon: pointMarkerIcon!,
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

  void _loadAllMarkerIcons() async {
    List<Vocation> vocations = Vocation.values.toList();
    Map<String, BitmapDescriptor> icons = {};
    for (Vocation vocation in vocations) {
      var imgPath = vocation.image.replaceFirst(RegExp(r'\.jpg$'), '_marker.png');
      print("imgPath: assets/img/vocations/markers/$imgPath");
      BitmapDescriptor icon = await _loadMarkerIcon('assets/img/vocations/$imgPath');
      icons[vocation.toString()] = icon;
    }
    setState(() {
      _allMarkerIcons = icons;
    });
    await initializeMarkers();
  }

  Future<BitmapDescriptor> _loadMarkerIcon(imgPath) async {
    try {
      final bytes = await rootBundle.load(imgPath);
      img.Image baseSizeImage = img.decodeImage(bytes.buffer.asUint8List())!;
      img.Image resizedImage = img.copyResize(baseSizeImage, width: 80, height: 80);
      img.Image circularImage = img.copyCropCircle(resizedImage);
      Uint8List finalImageBytes = Uint8List.fromList(img.encodePng(circularImage));
      final markerIcon = BitmapDescriptor.fromBytes(finalImageBytes);
      return markerIcon;
    } catch (e) {
      print('Error loading image: $e');
      throw e;
    }
  }

  void onCharacterSelected(String characterId) {
    setState(() {
      _markerFilterCharacter = characterId;
    });
    _updateMarkers();
    // initializePolylinePoints(_storeMarkers.map((marker) => PointLatLng(marker.position.latitude, marker.position.longitude)).toList());
  }

  late BitmapDescriptor? currentMarkerIcon;
  late BitmapDescriptor? pointMarkerIcon;

  Future<BitmapDescriptor> _loadCurrentMarkerIcon(imgPath) async {
    final bytes = await rootBundle.load(imgPath);
    img.Image baseSizeImage = img.decodeImage(bytes.buffer.asUint8List())!;
    img.Image resizedImage = img.copyResize(baseSizeImage, width: 80, height: 80);
    Uint8List finalImageBytes = Uint8List.fromList(img.encodePng(resizedImage));
    final markerIcon = BitmapDescriptor.fromBytes(finalImageBytes);
    return markerIcon;
  }

  void initializeCurrentMarkerIcon() async {
    try {
      final markerIcon = await _loadCurrentMarkerIcon('assets/img/map/currentPos2.png');
      final pointIcon = await _loadCurrentMarkerIcon('assets/img/map/location-pin2.png');
      setState(() {
        currentMarkerIcon = markerIcon;
        pointMarkerIcon = pointIcon;
        currentMarkerInitialized = true;
      });
    } catch (e) {
      print('Error loading current position marker icon: $e');
      setState(() {
        currentMarkerInitialized = true; // Still set to true to avoid infinite loading
      });
    }
  }

  // POLYLINES 
  bool isShowingPolyline = false;
  Set<Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  Future<void> createPolylinePoints(PointLatLng origin, PointLatLng destination, Color color, Set<Polyline> _polylines) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['GOOGLE_MAPS_API_KEY']!,
      origin,
      destination);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      _polylines.add(Polyline(
        polylineId: PolylineId("polyline"),
        color: color,
        points: polylineCoordinates,
        width: 5,
      ));

    } else {
      print(result.errorMessage);
    }
  }

  void initializePolylinePoints(List<PointLatLng> positions) async {
    Set<Polyline> _polylines = {};
    final List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow, Colors.purple, Colors.pink, Colors.orange, Colors.brown];
    
    for (int i = 0; i < positions.length - 1; i++) {
      createPolylinePoints(positions[i], positions[i+1], colors[i], _polylines);
    }
    print("the polylines after created: $_polylines");
    setState(() {
      polylines.clear();
      polylines = _polylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle("Map"),
        centerTitle: true,
      ),
      body: (_currentP == null || markersInitialized == false || currentMarkerInitialized == false )? const Center(child: CircularProgressIndicator()) : 
        Stack(
          children: [
            Stack(
              children: [
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
                    ...Set<Marker>.of(_storeMarkers),
                    ..._newMarker,
                    Marker(
                      markerId: const MarkerId("_currentLocation"),
                      icon: currentMarkerIcon!,
                      position: _currentP!,
                      infoWindow: InfoWindow(
                        title: "Current Location",
                        snippet: "${_currentP!.latitude}, ${_currentP!.longitude}",)
                    )
                  },
                  polylines: isShowingPolyline ? polylines :  {},
                ),

              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 210,
                width: 270,
                offset: 45),
                ],
            ),

            Positioned(
              bottom: 50.0, 
              left: 10.0, 
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: IconButton(
                      color: Colors.black,
                      onPressed: _toCurrentLocation,
                      icon: const Icon(Icons.my_location_outlined),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: isShowingPolyline ? Colors.blue : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: IconButton(
                      color: isShowingPolyline ? Colors.white : Colors.black,
                      onPressed: () {
                        setState(() {
                          isShowingPolyline = !isShowingPolyline;
                        });
                      },
                      icon: const Icon(Icons.route),
                    ),
                  ),
            ],)),

            Positioned(
              top: 15.0, 
              left: 20.0, 
              right: 20.0, 
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                        child: TextFormField(
                          controller: _searchController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Search location...",
                            hintStyle: const TextStyle(color: Colors.grey), 
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder( // Define border
                              borderRadius: BorderRadius.circular(50.0), // Set border radius
                              borderSide: BorderSide.none, // Remove border side
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          ),
                        )
                      ),
                  
                      Positioned(
                        right: 20.0, 
                        top: 0, 
                        bottom: 0, 
                        child: IconButton(
                          onPressed: () async {
                            var place = await LocationService().getPlace(_searchController.text);
                            _toPlace(place);
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                  ],),
                  
                  MarkerFilter(onCharacterSelected: onCharacterSelected),
                ],
              ),
            ),
          ],
        ),
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