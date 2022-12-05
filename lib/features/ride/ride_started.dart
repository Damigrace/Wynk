
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/utilities/constants/textstyles.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/models/directions.dart';
import '../../utilities/models/directions_model.dart';
import '../../utilities/widgets.dart';
import '../landing_pages/home_main14.dart';
import 'captain_trip_summary.dart';
class CaptainRideStarted extends StatefulWidget {

  @override
  State<CaptainRideStarted> createState() => _CaptainRideStartedState();
}

class _CaptainRideStartedState extends State<CaptainRideStarted> {
  String? tripPin;
  int? seconds;
  int? minutes;
  bool? timeOut;
  num? fair = 0;
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  bool showSpinner = false;
  Duration duration = Duration();
  late Function setSheetState;
  bool isSheetOpen = false;
  int? sec;

  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController?.dispose();
    tripPinController.clear();
    locationSubscription?.cancel();
  }
  // void onlineStat(int stat)async{
  //   final pos = await determinePosition(context);
  //   onlineStatus(stat, LatLng(pos.latitude, pos.longitude));
  //   originBitmap =  await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(),
  //     "lib/assets/images/originmarker.png",
  //   );
  // }
  @override
  void initState() {
    context.read<FirstData>().saveActiveRide(true);
    initSharedPref();
    // TODO: implement initState
    super.initState();

  }

  Future tripSummary(BuildContext context){
    context.read<FirstData>().saveActiveRide(false);
    return showModalBottomSheet(
      enableDrag: false,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return  CaptainTripSummary();
    });
  }
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  Location location = Location();
  LatLng? userCurLocat;
  double? rotation;
  showOpenMapSheet(){
    showModalBottomSheet(
        barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return Container(
        height: 200.h,
        width:devWidth ,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        padding: EdgeInsets.only(top: 6.h,left: 10.w,right: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('For better navigation, click the button below to use google map and click next to start navigating.',style: kBoldBlack.copyWith(fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
            SizedBox(height: 10.h,),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50.h,
                width: 300.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue),
                  onPressed:(){
                    Navigator.pop(context);
                    MapsLauncher.launchCoordinates(context.read<RideDetails>().destPos!.latitude, context.read<RideDetails>().destPos!.longitude);
                  },
                  child: Text('Open Google Map',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                ),
              ),
            )
          ],),);
    });
  }
  StreamSubscription?  locationSubscription;
  void GMapCont(GoogleMapController controller){
    Future.delayed(Duration(seconds: 3),(){
      showOpenMapSheet();
    });
    _googleMapController=controller;
    mapLocations();
    genIconBitMap();
    if(mounted){
      locationSubscription = location.onLocationChanged.listen((event) {
        setState(() {
          userCurLocat = LatLng(event.latitude!, event.longitude!);
          rotation = event.heading;
        });


        _googleMapController?.moveCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(event.latitude!,event.longitude!),
                zoom: 16))
        );
      });
    }
  }
  double? devWidth;
  double? devHeigth;
  double distance = 0;
  int time = 0;
  int waitMin = 0;
  int waitSec = 0;
  String place = '13 Abisoye John Street';
  String riderName = 'Victor';
  num lowerPrice = 1200;
  num upperPrice = 1700;
  final priceFormatter = NumberFormat("#,##0.00", "en_NG");
  Marker? curLocat;
  Directions? info;
  String? totalDuration;
  void mapLocations()async{
    final direct=await DirectionsRepo().getDirections(
        origin: context.read<RideDetails>().pickupPos??LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!),
         destination: context.read<RideDetails>().destPos!);
    setState(() {
      _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
      info=direct;
      totalDuration = info?.totalDuration;
    });

  }
  BitmapDescriptor? originBitmap;
  BitmapDescriptor? destBitmap;
  BitmapDescriptor? currentLocatBitmap;
  void genIconBitMap()async{
    originBitmap= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/originmarker.png",
    );
    destBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/greenmarker.png",
    );
    currentLocatBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/rides/car2.png",
    );
    setState(() {
    });
  }
  List<Marker> markers = [];
  void addMarker (LatLng latLng){
    Marker marker =Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('newLocation'),
        infoWindow: InfoWindow(title: 'New Location'),
        icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: latLng
    );
    markers.add(marker);
    setState(() {});
  }
  LatLng? start;
  LatLng? end;
  @override
  Widget build(BuildContext context) {

    String pickup = context.read<RideDetails>().pickUp!;
    String dest = context.read<RideDetails>().destination!;
    curLocat=Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'You are here'),
        icon: currentLocatBitmap?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: userCurLocat??LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!),
        rotation: rotation??0
    );
    origin=Marker(
      markerId: MarkerId('origin'),
      infoWindow: InfoWindow(title: 'Origin'),
      icon:context.read<FirstData>().startMarker?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: context.read<RideDetails>().pickupPos??LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!),
    );
    destination=Marker(
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: destBitmap??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position:context.read<RideDetails>().destPos??LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!)
    );
    devWidth=MediaQuery.of(context).size.width;
    devHeigth=MediaQuery.of(context).size.height;
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 7.5,
        target: LatLng(7.1091,5.1158));
    Set <Marker> mark = {
      if(origin!=null)origin!,
      if(destination!=null)destination!,
      if(curLocat!=null)curLocat!
    };
    markers.addAll(mark);
    return WillPopScope(
      onWillPop: ()async{
        return await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
            HomeMain14()));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(children: [
          GoogleMap(
            polylines: {
              if(info!=null)Polyline(
                polylineId: PolylineId('overview_polyline'),
                color: kBlue,
                width: 3,
                points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude))
                    .toList(),
              )
            },
            markers: markers.map((e) => e).toSet(),
            onMapCreated: GMapCont,
            myLocationEnabled: false,
            onTap: addMarker,
            zoomControlsEnabled: false,
            initialCameraPosition : initialCameraPosition,
          ),
          Positioned(
              top: 77.h,
              left: 25.w,
              child: backButton(context)),
          Positioned(
              bottom: 0,
              child: Container(
                height: 310.h,
                width: devWidth,
                child: Container(
                  height: 310.h,
                  width:devWidth ,
                  decoration: const BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(left: 15.w,top: 18.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:  CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${context.watch<RideDetails>().time} . ${context.watch<RideDetails>().distance} km',
                                  style: TextStyle(color: Colors.white,fontSize: 28.sp),),
                                SizedBox(height: 10.h,),
                                SizedBox(
                                    height: 50.h,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                            flex: 2,
                                            child: Container(
                                                width: 1000,
                                                height: 50.h,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  color: kYellow,
                                                ),

                                                child: Text('From:',style: TextStyle(color: Colors.white,fontSize: 18.sp),))),
                                        SizedBox(width: 7.w,),
                                        Flexible(
                                          flex: 6,
                                          child: GestureDetector(
                                            onTap: (){
                                              showDialog(context: context, builder: (context){
                                                return AlertDialog(
                                                  title: Text('Pick Up :'),
                                                  content: Text(pickup),
                                                );
                                              });

                                            },
                                            child: Text(pickup,
                                              style: TextStyle(color: Colors.white,fontSize: 20.sp),textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 10,),
                                Container(height: 1.5,color: kYellow,),
                                SizedBox(height: 10,),
                                SizedBox(
                                    height: 50.h,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                            flex: 2,
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: 50.h,
                                                width: 1000,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  color: kYellow,
                                                ),
                                                child: Text('To:',style: TextStyle(color: Colors.white,fontSize: 18.sp),))),
                                        SizedBox(width: 7.w,),
                                        Flexible(
                                          flex: 6,
                                          child: GestureDetector(
                                            onTap: (){
                                              showDialog(context: context, builder: (context){
                                                return AlertDialog(
                                                  title: Text('Destination:'),
                                                  content: Text(dest),
                                                );
                                              });
                                            },
                                            child: Text(dest,
                                              style: TextStyle(color: Colors.white,fontSize: 20.sp),textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],),),
                        ),
                        Expanded(
                            flex:2,
                            child: Padding(
                              padding:  EdgeInsets.only(top: 32.h,right: 40.w),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: 60.w,
                                      height: 60.h,
                                      child: CircleAvatar(backgroundImage:
                                      NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<RideDetails>().patronWynkid}.png'),
                                      )),
                                  SizedBox(height: 5.h,),
                                  FittedBox(child: Text('${context.watch<RideDetails>().riderName}',style: TextStyle(color: Colors.white,fontSize: 14.sp)))                        ],
                              ),
                            ))
                      ],),
                      Flexible(child: SizedBox(height: 40.h,)),
                      Container(
                        decoration: const BoxDecoration(
                            color: kYellow,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        ),
                        width: devWidth!,
                        height: 80.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                                Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                                Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                              ],
                            ),
                            GestureDetector(
                                onTap: ()async{
                                  spinner(context);
                                  print((context.read<RideDetails>().paymentMode));
                                  if(context.read<RideDetails>().paymentMode == 'cash'){

                                    final pos = await determinePosition(context);
                                    final res = await updateRideInfo(
                                        wynkid: context.read<FirstData>().uniqueId!,
                                        code: context.read<RideDetails>().rideCode!,
                                        currentPos: LatLng(pos.latitude, pos.longitude),
                                        rideStat: 9);
                                    Navigator.pop(context);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context, builder: (context){
                                      return AlertDialog(
                                        title: Text('Please Confirm Ride Payment: ₦${balanceFormatter.format(double.parse(res!['total'].toString()))}'),

                                        content: GestureDetector(
                                          onTap: ()async{
                                           // Navigator.pop(context);
                                            showDialog(context: context, builder: (context){
                                              return SpinKitCircle(color: kYellow,);
                                            });

                                            await patronHasPaid(context.read<RideDetails>().rideCode!);
                                            print('1');

                                            print('2');
                                            showToast(res['errorMessage'].toString());
                                            context.read<RideDetails>().saveFair(res['total'].toString());
                                            print('3');
                                            Navigator.pop(context);
                                            print('4');
                                            Navigator.pop(context);
                                            tripSummary(context);
                                            },
                                          child: Container(
                                            margin: EdgeInsets.only(top:10.h),
                                            width: MediaQuery.of(context).size.width,
                                            height: 51.h,
                                            decoration: BoxDecoration(
                                              color: kBlue,
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                            child: Center(
                                              child: Text('Patron has paid me.',
                                                style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                            ),
                                          ),),
                                      );
                                    });
                                  }
                                  else if(context.read<RideDetails>().paymentMode == 'wallet'){
                                    print('Ending ride');
                                    refresh(context);
                                    final pos = await determinePosition(context);
                                    final res = await updateRideInfo(
                                        wynkid: context.read<FirstData>().uniqueId!,
                                        code: context.read<RideDetails>().rideCode!,
                                        currentPos: LatLng(pos.latitude, pos.longitude),
                                        rideStat: 9);
                                    showToast(res!['errorMessage'].toString());
                                    context.read<RideDetails>().saveFair(res['total'].toString());
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    tripSummary(context);
                                  }
                                },
                                child: Text('END RIDE',style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.w500),)),
                            Row(
                              children: [
                                Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                                Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                                Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                              ],
                            ),
                          ],),
                      ),
                    ],),)
              )),
          Positioned(
            top: 400.h,
            right: 0,
            child: GestureDetector(
              child: CircleAvatar(

                backgroundColor:Colors.green,
                child: Icon(Icons.navigation_outlined),),
              onTap: (){
                showOpenMapSheet();
              },
            )
          )
        ],) ,),
    );
  }
}

