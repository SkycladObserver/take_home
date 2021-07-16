import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:take_home/map/model/directions.dart';

class RetrieveDirectionsFailure implements Exception {}

class DirectionsRepository {
  // probably need to put this apiKey somewhere else like an env file, but for
  // the sake of simplicity, i'll just leave this here.
  static const apiKey = "AIzaSyDPtl9rirbvT1TBOZDANivKfrJEFG1AhbQ";
  static const url = 'maps.googleapis.com';
  static const path = '/maps/api/directions/json';

  Future<Directions?> getDirections(
      {required LatLng origin, required LatLng destination}) async {
    try {
      final resp = await get(Uri.https(url, path, {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apiKey
      }));

      if (resp.statusCode == 200) {
        print(resp.body);
        return Directions.fromMap(jsonDecode(resp.body));
      }

      // if no directions, return null
      return Future.value(null);
    } catch (e) {
      print("Failed to retrieve directions.");
      rethrow;
    }
  }
}
