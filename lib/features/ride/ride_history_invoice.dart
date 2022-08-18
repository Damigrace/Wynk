import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/ride/nav_screen.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/pdf.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/models/directions.dart';
import '../../utilities/models/directions_model.dart';
import 'dart:ui' as ui;
import 'dart:io';
class RideHistoryPage extends StatefulWidget {

  @override
  _RideHistoryPageState createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  late CameraPosition startPos;
  late CameraPosition endPos;
  Uint8List? _imageFile;

  //Create an instance of ScreenshotController

  mapLocations()async{
    final direct=await DirectionsRepo().getDirections(origin: startPos.target, destination: endPos.target);
    setState(() {
      _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,30.w));
      info=direct;
    });
  }
  @override
  void dispose(){

    _googleMapController?.dispose();
    super.dispose();


  }
  @override
  void initState() {

    startPos=CameraPosition(target:  context.read<RideDetails>().pickupPos!);
    endPos=CameraPosition(target:  context.read<RideDetails>().destPos!);
    // TODO: implement initState
    super.initState();

  }

  GoogleMapController? _googleMapController;
  Marker? origin;

  Marker? destination;
  Directions? info;

  void GMapCont(GoogleMapController controller){
    context.read<FirstData>().backButton(false);
    _googleMapController=controller;
    mapLocations();
  }
  double? devWidth;
  GlobalKey _globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    origin=Marker(
      anchor: Offset(0.5,0.5),
      markerId: MarkerId('origin'),
      infoWindow: InfoWindow(title: 'You are here'),
      icon:context.read<FirstData>().startMarker?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position:startPos.target,
    );
    destination=Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: context.read<FirstData>().destMarker??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: endPos.target
    );
    devWidth=MediaQuery.of(context).size.width;
    List<Marker> markers = [
      if(origin!=null)origin!,
      if(destination!=null)destination!,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _key,
      drawer: Drawer(
        width: 250.w,
        child: DrawerWidget(),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only( top: 15.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: Image.asset('lib/assets/menu.webp'),
                        ),
                      ),
                    ),
                    SizedBox(height: 52.h,),
                    Text('Ride History',style: TextStyle(fontSize: 26.sp),),
                    SizedBox(height: 21.h,),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: Image.asset('lib/assets/images/greenmarker.png')),
                            SizedBox(width: 21.w,),
                            Expanded(
                              child: Text( context.read<RideDetails>().pickUp!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 18.sp),),)
                          ],
                        ),
                        IntrinsicHeight(
                          child: Row(children: [
                            SizedBox(height: 38.h,width: 9.w,),
                            VerticalDivider(width: 3,color: Colors.black,),
                            SizedBox(height: 38.h,)
                          ],),
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: Image.asset('lib/assets/images/redmarker.png')),
                            SizedBox(width: 21.w,),
                            Expanded(
                              child: Text( context.read<RideDetails>().destination!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 18.sp),),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h,),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: 390.w,
                  //height: 175.h,
                  child: GoogleMap(
                    polylines: {
                      if(info!=null)Polyline(
                        polylineId: PolylineId('overview_polyline'),
                        color: kBlue,
                        width: 3,
                        points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                    },
                    markers: markers.map((e) => e).toSet(),
                    onMapCreated: GMapCont,
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition : startPos,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 29.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your ride with ${context.read<RideDetails>().riderName}',style: TextStyle(fontSize: 16.sp),),
                            SizedBox(height: 10.h,),
                            // Text(context.read<CaptainDetails>().capPlate!,style: TextStyle(fontSize: 18.sp)),
                            // SizedBox(height: 22.h,),
                            Text('${context.read<RideDetails>().pickupDate}',style: TextStyle(fontSize: 18.sp),)
                          ],),
                        // SizedBox(
                        //   width: 80.w,
                        //   height: 80.h,
                        //   child: CircleAvatar(
                        //     backgroundImage: NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<RideDetails>().patronWynkid}.png'),),
                        // )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 393.w,
                height: 61.h,
                padding: EdgeInsets.only(left: 36.w, right: 36.w),
                decoration: BoxDecoration(
                    border: Border.all(color: kGrey1)
                ),
                child: Center(child: Row(children: [
                  Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                  SizedBox(width: 18.w,),
                  Flexible(child: SizedBox(width:260.w,child: Text('My Vault',style: TextStyle(fontSize: 18.sp),))),
                  Text('₦ ${context.read<RideDetails>().fair!}',style: TextStyle(fontSize: 18.sp))
                ],) ,),
              ),
              GestureDetector(
                onTap:()async{
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                     HomeMain14()));

                  // _imageFile = await _googleMapController?.takeSnapshot();
                  // ImageGallerySaver.saveImage(_imageFile!);
                  // showModalBottomSheet(context: context, builder: (context){
                  //   return Image.memory(_imageFile!);});


                } ,
                child: Container(
                  width: 318.h,
                  margin: EdgeInsets.only(left: 36.w, right: 36.w, top: 15.h),
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text('Return to Home',
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: kWhite)),
                  ),
                ),),
              SizedBox(height: 15.h,),
            ],
          ),
        ),
      ),
    );
  }
}
