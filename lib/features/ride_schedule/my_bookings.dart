
import 'dart:async';
import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/landing_pages/captain_online.dart';
import 'package:untitled/features/registration_feature/captain_f_registration.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/features/later_screens/activities.dart';
import 'package:untitled/features/ride_schedule/ride_schedule%20pickup.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
import 'package:location/location.dart';

import '../later_screens/deliveries.dart';


class MyBookingsMVP extends StatefulWidget {
  const MyBookingsMVP({Key? key}) : super(key: key);

  @override
  State<MyBookingsMVP> createState() => _MyBookingsMVPState();
}

class _MyBookingsMVPState extends State<MyBookingsMVP> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;

  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey();


  final screens = [
    Activities(),
    Deliveries(),
  ];
  String title = 'My Bookings';
  int index = 0;
  bool isActButPressed = true;
  bool isDelButPressed = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 0,
        title:Text('My Bookings',style: TextStyle(fontSize: 26.sp,color: Colors.black)),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap:  () { _key.currentState!.openDrawer();},
                child: Image.asset('lib/assets/menu.webp'),
              )
          ),
        ],
      ),
      key: _key,
      drawer:  Drawer(
        elevation: 0,
        backgroundColor: Colors.white,
        width: 250.w,
        child: DrawerWidget()
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.h)
                  ),
                    backgroundColor: isActButPressed == true?Colors.black12:Colors.white),
                  onPressed: (){setState(() {
                    index = 0;
                    isActButPressed = true;
                    isDelButPressed = false;
                  });}, child: Text('Activities',style: TextStyle(color: Colors.black),)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.h)
                      ),
                      backgroundColor: isDelButPressed == true?Colors.black12:Colors.white),
                  onPressed: (){
                    setState(() {
                      index = 1;
                      isActButPressed = false;
                      isDelButPressed = true;
                    });
                  }, child: Text('Deliveries',style: TextStyle(color: Colors.black))),
            ],),
          ),
          Expanded(
            child: IndexedStack(
              children: screens,
              index: index,
            ),
          ),
        ],
      ),);
  }
}

