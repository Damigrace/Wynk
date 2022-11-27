
import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/features/ride/ride_destination.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/models/directions.dart';
import 'package:wynk/utilities/models/directions_model.dart';
import 'package:wynk/utilities/widgets.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../local_notif.dart';
class RideHome extends StatefulWidget {
  const RideHome({Key? key}) : super(key: key);

  @override
  State<RideHome> createState() => _RideHomeState();
}

class _RideHomeState extends State<RideHome> {
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController?.dispose();
  }
  Position? pos;
  LatLng? userCurLocat;
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
  }
  GoogleMapController? _googleMapController;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Circle? circle;
  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 16.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    circle = Circle(
      strokeWidth: 5,
      strokeColor: kYellow,
      fillColor: kBlue,
      circleId: CircleId('current'),
      radius: 10,
      center: userCurLocat??initialCameraPosition.target,
    );
    return Scaffold(
      key: _key,
      drawer:  Drawer(
        width: 250.w,
        child: DrawerWidget(),
      ),
      body: Stack(children: [
      GoogleMap(
        circles: {
          if(circle!=null)circle!,
        },
        markers: context.watch<FirstData>().captains.map((e) => e).toSet(),
        compassEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition : initialCameraPosition,
      ),
      Positioned(
        bottom: 0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            padding: EdgeInsets.only(left: 25.w,right: 26.w,top: 20.h),
            child: Column(children: [
              Image.asset('lib/assets/images/handle.png',width: 57.w,height: 12.h,),
              SizedBox(height: 17.h,),
              Container(
                color: Color(0xffF4F4F9),
                child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(focusColor: kBlue,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Where to?',
                        contentPadding: EdgeInsets.all(15),
                        border: InputBorder.none),
                    onTap:() async{
                      showDialog(
                          barrierDismissible: false,
                          context: context, builder: (context){
                        return Container(child:
                        SpinKitCircle(
                          color: kYellow,
                        ),);
                      });
                      context.read<FirstData>().topBar(true);
                      Position position =await determinePosition(context);
                      List <Placemark> pickup = await placemarkFromCoordinates(position.latitude, position.longitude);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                       RideDestination(userLocation: pickup[0].street)
                      ));
                    }
                ),
              ),
              SizedBox(height: 10.h,),

            ],),)
        ),
      ),Positioned(
          top: 65.h,
          right: 28.w,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: GestureDetector(
              onTap:  () { _key.currentState!.openDrawer();},
              child: Image.asset('lib/assets/menu.webp'),
            ),
          ),
        ),
    ],) ,);
  }
}