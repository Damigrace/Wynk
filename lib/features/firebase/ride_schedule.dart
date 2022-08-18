
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';



Future<void> SaveBooking(
    String? destination,
    String? date,
    String? time,
    LatLng? startLocation,
    LatLng? endLocation
    )
async{
  String rideSchedule = 'location1';
  CollectionReference user = FirebaseFirestore.instance.collection(rideSchedule);
  SharedPreferences prefs = await  SharedPreferences.getInstance();
  final col = user.doc(prefs.getString('Origwynkid')).collection('${'My ride bookings'}');
  col.add({
    'Destination':destination,
    'Date': date,
    'Time': time,
    'OriginLat':startLocation?.latitude,
    'OriginLong':startLocation?.longitude,
    'DestinationLat':endLocation?.latitude,
    'DestinationLong':endLocation?.longitude,
  });
}
Future<QuerySnapshot<Map<String, dynamic>>> getBookings(BuildContext context)async{
  String rideSchedule = 'location1';
  CollectionReference user = FirebaseFirestore.instance.collection(rideSchedule);
  QuerySnapshot<Map<String, dynamic>> getRideBookings = await user.doc(context.read<FirstData>().uniqueId).collection('My ride bookings').get();
  getRideBookings.docs.forEach((element) {
   print(element['Destination']);
 });
return getRideBookings;

}
class RideSchedule extends StatelessWidget {
  String? name;
  String? bookingNum;
  //
  RideSchedule({this.name,this.bookingNum});
  static String rideSchedule = 'ride_schedule';
  CollectionReference user = FirebaseFirestore.instance.collection(rideSchedule);

  Future<void> getBookings()async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    final books = user.doc(prefs.getString('Origwynkid')).collection('ride booking details').doc(bookingNum).get();


  }
  Future<DocumentReference<Object?>> saveRideSchedule()async {

    return user.add({'name':'ade'});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  user.doc('another_user').collection('ride booking details').doc(bookingNum).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          Map<String, dynamic> data = snapshot.data!;
          print('data from database: ${data['name']}');
        }
        return Container();
      },);
  }
}


