
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/landing_pages/captain_online.dart';
import 'package:untitled/features/registration_feature/captain_f_registration.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
class CaptainHome extends StatefulWidget {
  const CaptainHome({Key? key}) : super(key: key);

  @override
  State<CaptainHome> createState() => _CaptainHomeState();
}

class _CaptainHomeState extends State<CaptainHome> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  num vaultBalance=0;
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
      Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(),
            SizedBox(height: 10.h,),
            Text('₦${balanceFormatter.format(vaultBalance)}', style:TextStyle(color: Colors.green,fontSize: 18.sp),),
            Padding(
              padding:  EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.eye_slash_fill),
                  SizedBox(width: 10.w,),
                  Text( 'Vault Balance',style:TextStyle(color: Colors.black87,fontSize: 18.sp))
                ],
              ),
            ),
          ],),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        color: Colors.white54,
        child: ListView.builder(
          shrinkWrap: true,
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
      drawer:  Drawer(elevation: 0,
        backgroundColor: Colors.white,
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
            height: 61.h,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      primary: kBlue),
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                   bool? captRegStat = prefs.getBool('capRegStat');
                   if(captRegStat == true){
                     print('Captain Registered');
                     Navigator.push(
                         context, MaterialPageRoute(builder: (context) => const CaptainOnline()
                     ));
                   }
                   else{
                     Navigator.push(
                         context, MaterialPageRoute(builder: (context) => const CaptainFRegistration()
                     ));
                   }
                  },
                  child: Text('GO ONLINE',style: TextStyle(fontSize: 15.sp),),
                ),)
          ),
        ),
        Positioned(
          top: 80.h,
          right: 28.w,
          child: GestureDetector(
            onTap:  () { _key.currentState!.openDrawer();},
            child: Image.asset('lib/assets/menu.webp'),
          ),
        ),
        UserProfileHeader(),
      ],) ,);
  }
}

