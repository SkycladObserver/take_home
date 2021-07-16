import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  const Directions(
      {this.bounds, this.polylinePoints, this.distance, this.duration});

  final LatLngBounds? bounds;
  final List<PointLatLng>? polylinePoints;
  final String? distance;
  final String? duration;

  static Directions? fromMap(Map<String, dynamic> map) {
    // if no route info at all, return null
    if (map['routes'].isEmpty) {
      return null;
    }

    final data = map['routes'][0];
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
        northeast: LatLng(northeast['lat'], northeast['lng']),
        southwest: LatLng(southwest['lat'], southwest['lng']));

    String distance = '';
    String duration = '';
    if (data['legs'].isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    final polylinePoints =
        PolylinePoints().decodePolyline(data['overview_polyline']['points']);

    return Directions(
        bounds: bounds,
        polylinePoints: polylinePoints,
        distance: distance,
        duration: duration);
  }
}
