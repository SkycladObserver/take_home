import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  const Directions(
      {this.htmlInstructions = const [],
      this.polylinePoints = const [],
      this.distance = '',
      this.duration = ''});

  final List<String> htmlInstructions;
  final List<PointLatLng> polylinePoints;
  final String distance;
  final String duration;

  static Directions? fromMap(Map<String, dynamic> map) {
    // if no route info at all, return null
    if (map['routes'].isEmpty) {
      return null;
    }

    final data = map['routes'][0];
    String distance = '';
    String duration = '';
    List<String> htmlInstructions = [];

    if (data['legs'].isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
      htmlInstructions = leg['steps']
          .map((step) => step['html_instructions'])
          .toList()
          .cast<String>();
    }

    final polylinePoints =
        PolylinePoints().decodePolyline(data['overview_polyline']['points']);

    return Directions(
        htmlInstructions: htmlInstructions,
        polylinePoints: polylinePoints,
        distance: distance,
        duration: duration);
  }
}
