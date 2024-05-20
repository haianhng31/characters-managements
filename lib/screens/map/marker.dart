// import 'package:flutter/material.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class CustomMarker extends StatefulWidget {
//   const CustomMarker({
//     super.key,
//     required this.controller
//   });

//   final CustomInfoWindowController controller;

//   @override
//   State<CustomMarker> createState() => _CustomMarkerState();
// }

// class _CustomMarkerState extends State<CustomMarker> {
//   final List<Marker> _markers = <Marker>[]; 

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Marker(
//       markerId: MarkerId(widget.controller.markerId),
//       position: widget.controller.position,
//       onTap: () {
//         widget.controller.onTap();
//       },
//       icon: widget.controller.icon,
//     );
//   }
// }