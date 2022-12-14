import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions{
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;
  static var  bbounds;
  const Directions({required this.bounds,required this.totalDuration,required this.totalDistance,required this.polylinePoints});
  factory Directions.fromMap(Map<String,dynamic> map){
    final data = Map<String, dynamic>.from(map['routes'][0]);
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );
    bbounds=bounds;
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
        bounds: bounds,
        totalDuration: duration,
        totalDistance: distance,
        polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']));
  }
}