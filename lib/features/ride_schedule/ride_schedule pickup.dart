
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/features/ride_schedule/ride_schedule_dest.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
class RideSchedule extends StatefulWidget {
  const RideSchedule({Key? key}) : super(key: key);

  @override
  State<RideSchedule> createState() => _RideScheduleState();
}

class _RideScheduleState extends State<RideSchedule> {
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController?.dispose();

  }
  void setPTime()async{
    showDialog(context: context, builder: (context){
      return Container(child:
      SpinKitCubeGrid(
        color: kYellow,
      ),);
    });
    Position pos = await determinePosition(context);
    List <Placemark> pickup = await placemarkFromCoordinates(pos.latitude,pos.longitude);
    Navigator.pop(context);
    DateFormat formatter = DateFormat.MMMMEEEEd();
    final pickupD = formatter.format(DateTime(startYear,dateTime.month,dateTime.day));
    pickupDate = pickupDate??pickupD;
    context.read<RideBooking>().savePickupDate(pickupDate);
    context.read<RideBooking>().savePickupTime(pickupTime);
    context.read<RideBooking>().savePickupPos(LatLng(pos.latitude,pos.longitude));
    context.read<RideBooking>().savePickupPlace(pickup[0].street);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RideSchDestination();
    }));
  }
  Position? pos;
  String? pickupDate;
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
    startYear = dateTime.year;
    print(dateTime);
  }
  GoogleMapController? _googleMapController;
  Marker? origin;

  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
  }
  double? devWidth;
  String? pickupTime;
  late DateTime dateTime;
  late int startYear;
  @override
  Widget build(BuildContext context) {
   devWidth = MediaQuery.of(context).size.width;
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 16.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    origin=Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'You are here'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: initialCameraPosition.target
    );
    var time;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            liteModeEnabled: true,
            markers: {
              if(origin!=null)origin!,
            },
            onMapCreated: GMapCont,
            zoomControlsEnabled: false,
            initialCameraPosition : initialCameraPosition,
          ),
          Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 546.h,
                width:devWidth,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Schedule a ride'),
                        Image.asset('lib/assets/images/rides/cancel1.png',width: 33.w,height: 33.w,)
                    ],),
                    SizedBox(height: 9.h,),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 300.h,
                        child: Column(
                          children: [
                            Container(
                              height: 270.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)
                              ),
                              width: devWidth,
                              child: CalendarDatePicker(
                                currentDate: dateTime,
                                firstDate: DateTime(startYear,dateTime.month,dateTime.day),
                                initialDate: DateTime(startYear,dateTime.month,dateTime.day),
                                lastDate: DateTime(startYear + 1),
                                onDateChanged: (DateTime value) {
                                  DateFormat formatter = DateFormat.MMMMEEEEd();
                                  final pickupD = formatter.format(value);
                                  pickupDate = pickupD.toString();
                                  print(pickupDate);},),
                            ),
                            SizedBox(height: 30.h,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.w,),
                    Row(
                      children: [
                        Expanded(
                          flex:5,
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                              ),
                              child: Center(child: Text(pickupTime??'Set pick up time    👉',style: TextStyle(color: kYellow),)),
                              height: 56.h,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: ()async{
                             final time = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 12, minute: 0));
                              setState(() {
                                pickupTime = time?.format(context).toString();
                              });
                            },
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.access_time),
                                height: 56.h,

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top:26.h ),
                      height: 51.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue),
                        onPressed: pickupTime == null? null:setPTime ,
                        child: Text('Set pickup time',style: TextStyle(fontSize: 15.sp),),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ) ,);
  }
}