
import 'dart:async';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
class RiderAvailable extends StatefulWidget {
  Position position;
  RiderAvailable({required this.position});
  @override
  State<RiderAvailable> createState() => _RiderAvailableState();
}

class _RiderAvailableState extends State<RiderAvailable> {
  // late CameraPosition startPos;
  // late CameraPosition endPos;
  // void mapLocations()async{
  //   final direct=await DirectionsRepo().getDirections(origin: LatLng(5.23,3.4), destination: LatLng(17.23,15.4));
  //   setState(() {
  //     _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,100.w));
  //     info=direct;
  //   });
  // }
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController?.dispose();

  }
  @override
  void initState() {
    position = widget.position;
    polylinePoints = PolylinePoints();
    initSharedPref();
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 1), (){mBS(context);});
  }
  Future mBS(BuildContext context){
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return Container(
        height: 341.h,
        width:devWidth ,
        decoration: const BoxDecoration(
            color: kBlue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 15.h),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 40.w,top: 36.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text('$time min. ${distance}km',style: TextStyle(color: Colors.white,fontSize: 30.sp),),
                      Text(place,style: TextStyle(color: Colors.white,fontSize: 20.sp))
                    ],),),
              ),
              Expanded(
                  flex:2,
                  child: Padding(
                    padding:  EdgeInsets.only(top: 32.h,right: 40.w),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 30.r,),
                        Text(riderName,style: TextStyle(color: Colors.white,fontSize: 14.sp))
                      ],
                    ),
                  ))
            ],),
            Container(
              margin: EdgeInsets.only(left: 40.w,top: 31.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Text('PRICE ESTIMATE',style: TextStyle(color: Colors.grey,fontSize: 12.sp),),
                  Text('₦${priceFormatter.format(lowerPrice)} - ₦${priceFormatter.format(upperPrice)}',
                      style: TextStyle(color: Colors.white,fontSize: 28.sp))
                ],),),
            Flexible(
              child: Container(
                margin:  EdgeInsets.only(top: 36.h),
                width: devWidth,
                height: 200.h,
                decoration: const BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      acceptMBS(context);
                    },
                    child: Container(
                      width: 132.w,height: 51.h,
                      decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(child: Text('Accept')),
                    ),
                  ),
                    GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: 132.w,height: 51.h,
                      decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(child: Text('Decline')),
                    ),
                  )
                ],),
              ),
            )
          ],),);
    });
  }
  Future acceptMBS(BuildContext context){
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return Container(
        height: 309.h,
        width:devWidth ,
        decoration: const BoxDecoration(
            color: kBlue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 15.h),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 40.w,top: 36.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text('$time min. ${distance}km',style: TextStyle(color: Colors.white,fontSize: 30.sp),),
                      Text(place,style: TextStyle(color: Colors.white,fontSize: 20.sp))
                    ],),),
              ),
              Expanded(
                  flex:2,
                  child: Padding(
                    padding:  EdgeInsets.only(top: 32.h,right: 40.w),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 30.r,),
                        Text(riderName,style: TextStyle(color: Colors.white,fontSize: 14.sp))
                      ],
                    ),
                  ))
            ],),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                margin: EdgeInsets.only(top: 41.h),
                width: devWidth,
                height: 400,
                child: Stack(children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    width: devWidth,
                    height: 94.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                          Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                          Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                        ],
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            startRideMBS(context);
                          },
                          child: Text('ARRIVED',style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.w500),)),
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                          Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                          Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                        ],
                      ),
                    ],),
                  ),
                  Positioned(
                      top: 80.h,
                      child:Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        ),
                        width: devWidth!-10.w,
                        height: 81.h,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/assets/images/ios_call.png',height: 52.w,width: 52.w,),
                              SizedBox(width: 9.w,),
                              Image.asset('lib/assets/images/ios_message.png',height: 52.w,width: 52.w,),
                              SizedBox(width: 9.w,),
                              Image.asset('lib/assets/images/call_cancel.png',height: 52.w,width: 52.w,)
                            ],),
                        ),
                      ),)
                ],),
              ),
            )
          ],),);
    });
  }
  Future startRideMBS(BuildContext context){
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return Container(
        height: 309.h,
        width:devWidth ,
        decoration: const BoxDecoration(
            color: kBlue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 15.h),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 40.w,top: 36.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text('${waitMin}min ${waitSec}s',style: TextStyle(color: Colors.white,fontSize: 30.sp),),
                      Text('Waiting Time',style: TextStyle(color: Colors.white,fontSize: 20.sp))
                    ],),),
              ),
              Expanded(
                  flex:2,
                  child: Padding(
                    padding:  EdgeInsets.only(top: 32.h,right: 40.w),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 30.r,),
                        Text(riderName,style: TextStyle(color: Colors.white,fontSize: 14.sp))
                      ],
                    ),
                  ))
            ],),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                margin: EdgeInsets.only(top: 41.h),
                width: devWidth,
                height: 400,
                child: Stack(children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    width: devWidth,
                    height: 94.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                            Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                            Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                          ],
                        ),
                        GestureDetector(
                            onTap: (){},
                            child: Text('START TRIP',style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.w500),)),
                        Row(
                          children: [
                            Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                            Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                            Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                          ],
                        ),
                      ],),
                  ),
                  Positioned(
                    top: 80.h,
                    child:Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      width: devWidth!-10.w,
                      height: 81.h,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('lib/assets/images/ios_call.png',height: 52.w,width: 52.w,),
                            SizedBox(width: 9.w,),
                            Image.asset('lib/assets/images/ios_message.png',height: 52.w,width: 52.w,),
                            SizedBox(width: 9.w,),
                            Image.asset('lib/assets/images/call_cancel.png',height: 52.w,width: 52.w,)
                          ],),
                      ),
                    ),)
                ],),
              ),
            )
          ],),);
    });
  }
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
    mapLocations();
    genIconBitMap();
    setPolylines();
  }
  void setPolylines()async{
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,

        PointLatLng( position.latitude,position.longitude),
        PointLatLng(7.2571,5.2058));
    if(result.status == 'OK'){
      print('ok');
      result.points.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));
      });
      setState(() {
        _polylines.add(
          Polyline(width: 3,
              polylineId: PolylineId('polyline'),
              color:Color(0xff211E8A) ,
              points: polylineCoordinates)
        );
      });
    }
  }
  late Position position;
  double? devWidth;
  double distance = 0;
  int time = 0;
  int waitMin = 0;
  int waitSec = 0;
  String place = '13 Abisoye John Street';
  String riderName = 'Victor';
  num lowerPrice = 1200;
  num upperPrice = 1700;
  final priceFormatter = NumberFormat("#,##0.00", "en_NG");
  BitmapDescriptor? originBitmap;
  BitmapDescriptor? destBitmap;
  void mapLocations()async{
    setState(() {
      _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(LatLngBounds(
        southwest: LatLng(position.latitude,position.longitude),
        northeast: LatLng( 7.2571,5.2058),
      ),120.w));
    });
  }
  void genIconBitMap()async{
    originBitmap= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/originmarker.png",
    );
    destBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/destinationmarker.png",
    );
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {

    origin=Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'Origin'),
        icon:originBitmap?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng( position.latitude,position.longitude)
    );
    destination=Marker(
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: destBitmap??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng( 7.2571,5.2058)
    );
    devWidth=MediaQuery.of(context).size.width;
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 7.5,
        target: LatLng(7.1091,5.1158));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        GoogleMap(
          polylines: _polylines,
          markers: {
            if(origin!=null)origin!,
            if(destination!=null)destination!,
          },

          onMapCreated: GMapCont,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition : initialCameraPosition,
        ),
        Positioned(
            bottom: 0,
            child: Container(
              width: devWidth,
              child: GestureDetector(
                onTap: (){mBS(context);},
                child: Image.asset('lib/assets/images/handle.png')
        ),
            ))
      ],) ,);
  }
}

