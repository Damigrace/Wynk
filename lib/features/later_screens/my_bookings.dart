
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
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
import 'package:location/location.dart';

import 'deliveries.dart';
class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  num vaultBalance=0;
  @override

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
    Container(),
    Deliveries(),
  ];
  String title = 'My Bookings';
  int index = 1;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 0,
        title:Text(title,style: TextStyle(fontSize: 26.sp,color: Colors.black)),
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
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (val)async{
          setState(() {
            index = val;
          });
          if(val == 0){title='My Activities';}
          else if(val == 1){
            setState(() {
              title = 'My Bookings';
            });
            await showDialog(context: context, builder: (context){
              return AlertDialog(
                contentPadding: EdgeInsets.all(30.w),
                shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 170.w,
                      child: Text('Do you want to close this booking session',
                        style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    ),
                    GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                        Navigator.popUntil(context, ModalRoute.withName('/RideSchedule'));
                      } ,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top:30.h),
                        height: 51.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.black)
                        ),
                        child: Center(
                          child: Text('Yes',
                              style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
                        ),
                      ),),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);},
                      child: Container(
                        margin: EdgeInsets.only(top:10.h),
                        width: MediaQuery.of(context).size.width,
                        height: 51.h,
                        decoration: BoxDecoration(
                          color: kBlue,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text('No',
                            style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                        ),
                      ),)
                  ],
                ),
              );
          });}
          else{title='My Deliveries';}
        },
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: kYellow,
          color: kBlue,
          height: 60.h,
          items:[
            Icon(Icons.local_activity,color: Colors.white,),
            Icon(Icons.home,color: Colors.white,),
            Icon(Icons.directions_car_sharp,color: Colors.white,),
          ]) ,
      key: _key,
      drawer:  Drawer(elevation: 0,
        backgroundColor: Colors.white,
        width: 250.w,
        child: DrawerWidget(),
      ),
      body: screens[index] ,);
  }
}

