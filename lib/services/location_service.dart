import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class LocationService {
  final String key = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  Future<String> getPlaceId(String input) async {
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  // Future<String> getPlaceIdFromLocation(LatLng location) async {
  //   final url =
  //       'https://maps.googleapis.com/v1/places:searchNearby?key=$key';

  //   final requestBody = {
  //     "includedTypes": [
  //       "restaurant"
  //     ],
  //     "maxResultCount": 10,
  //     "locationRestriction": {
  //       "circle": {
  //         "center": {
  //           "latitude": location.latitude,
  //           "longitude": location.longitude
  //         },
  //         "radius": 500
  //       }
  //     }
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: convert.jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = convert.jsonDecode(response.body);
  //       print(data);
  //       return data['places'];
        
  //     }
  //   } catch (e) {
  //     print('Error getting place ID: $e');
  //   }

  //   return '';
  // }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final String placeId = await getPlaceId(input);
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    print(results);
    return results;
  }

 
}