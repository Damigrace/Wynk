import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/env.dart';
import 'directions_model.dart';

class DirectionsRepo{
  // https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=YOUR_API_KEY
  static const String baseUrl="https://maps.googleapis.com/maps/api/directions/json?";
  Future<Directions?> getDirections({required LatLng origin, required LatLng destination})async{
    final response=await http.get(
        Uri.parse("${baseUrl}origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey"));
    if(response.statusCode==200){

      return Directions.fromMap(jsonDecode(response.body));}
    print('${jsonDecode(response.body)},rp');
      return null;
    }
  }