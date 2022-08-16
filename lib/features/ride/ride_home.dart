
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
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
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  GoogleMapController? _googleMapController;
  Marker? origin;

  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
  }
  Timer? debouce;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<String> drawerItems=[
    'Home',
    'Rides',
    'Payments',
    'My Vault',
    'Inbox',
    'Settings',
    'Support',
    'Terms & Conditions',
    'Log Out'
  ];

  wynkDrawer(){
    return  ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(prefs?.getString('wynkid')??'User'),
        currentAccountPicture: CircleAvatar(radius: 28.r,
          child: ClipRect(child: Image.asset('lib/assets/images/wynkimage.png',scale: 4,)),), accountEmail: null,),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        color: Colors.white54,
        height:400.h,
        child: ListView.builder(
          itemCount: drawerItems.length,
          itemBuilder: (context,index)=>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(drawerItems[index],style: TextStyle(fontSize: 18.sp),),
              SizedBox(height: 20.h,)

            ],),),
      )
    ],);
  }
  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 11.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    origin=Marker(
      markerId: MarkerId('origin'),
      infoWindow: InfoWindow(title: 'Origin'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: initialCameraPosition.target
    );

    return Scaffold(
      key: _key,
      drawer:  Drawer(
        width: 250.w,
        child: wynkDrawer(),
      ),
      body: Stack(children: [
      GoogleMap(
        markers: {
          if(origin!=null)origin!,
        },

        onMapCreated: GMapCont,
        myLocationEnabled: true,
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
                      context.read<FirstData>().topBar(true);
                      Position position =await determinePosition(context);
                      List <Placemark> pickup = await placemarkFromCoordinates(position.latitude, position.longitude);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                       RideDestination(userLocation: pickup[0].street)
                      ));
                    }
                ),
              ),
              SizedBox(height: 10.h,),

            ],),)
        ),
      ),
        Positioned(
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