
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/local_notif.dart';
import 'package:untitled/features/modal_bottom_sheets/driver_found_mbs.dart';
import 'package:untitled/features/ride/patron_ride_commence.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../modal_bottom_sheets/driver -search_mbs.dart';
class CaptainFound extends StatefulWidget {

  BitmapDescriptor? originBitmap;
  String? wynkid;
  CaptainFound({Key? key,this.wynkid,this.originBitmap}) : super(key: key);

  @override
  State<CaptainFound> createState() => _CaptainFoundState();
}

class _CaptainFoundState extends State<CaptainFound> {

  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  double minChildSize = 0.1;
  double minChildSize1 = 0.2;
  void endProcesses(){
    print('starting destruction');
    timer?.cancel();
    print('cancelled timer');
    _googleMapController?.dispose();
    print('disposed gmap controller');
    locationSubscription?.cancel();
    print('cancelled subscription');
  }
  @override
  void dispose() {
    endProcesses();
    super.dispose();
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    endProcesses();
    super.deactivate();
  }
  late CameraPosition startPos;
  late GooglePlace googlePlace;
  String? totalDuration;

  LatLng? capCurrLocat;
  @override
  void initState() {
    startPos=CameraPosition(target:context.read<FirstData>().patronCurentLocation??
    LatLng(context.read<FirstData>().startPos!.geometry!.location!.lat!,
        context.read<FirstData>().startPos!.geometry!.location!.lng!)
        ,zoom: 11);
    String apikey=apiKey;
    googlePlace=GooglePlace(apikey);
    initSharedPref();
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 30), (_)async {
      final det = await getCapDetails(context.read<CaptainDetails>().capId);
      capCurrLocat = LatLng(double.parse(det['current_lat']), double.parse(det['current_long']));
      _googleMapController?.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: capCurrLocat!,
              zoom: 16))
      );
    });
    super.initState();

  }
  StreamSubscription? locationSubscription;
  bool showTopNav = true;
  bool showBackButton = false;
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? curLocat;
  Marker? destination;
  Directions? info;
  Location location = Location();
  Timer? timer;
  bool notified1 = false;
  bool notified2 = false;
  bool notified3 = false;
  bool notified4 = false;
  void mapLocations()async{
    final direct = await DirectionsRepo().getDirections(
        origin:  context.read<CaptainDetails>().captainLocation!,
        destination: startPos.target);
    setState(() {
      _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
      info=direct;
      totalDuration = info?.totalDuration;
    });
    context.read<FirstData>().checkRideStarted(context.read<CaptainDetails>().rideCode!);
    timer = Timer.periodic(Duration(seconds: 10), (_) async {
      print('checking if ride started');
      dynamic val = await rideStatus(rideCode: context.read<CaptainDetails>().rideCode!);
      switch(val['status_code']){
        case '7':
          {
            if(notified2 == false){
              NotificationService.showNotif('Wynk', 'Captain has arrived.\nYour Trip pin is ${val['otp']}');
              context.read<CaptainDetails>().saveCapArrInfo('Your captain is here');
              notified2 = true;
            }}break;
        case '8':
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RideCommence()));
          NotificationService.showNotif('Wynk', 'Ride has started');
          timer?.cancel();
          break;
      }
    });
  }
  //LatLng? captainCurrentLocation;
  // getCaptainCurrLocation(BuildContext context)
  // {
  //   timer = Timer.periodic(const Duration(seconds: 60), (timer)async {
  //     captainCurrentLocation = await determinePosition(context);
  //     LatLng userCoord = LatLng(captainCurrentLocation!.latitude,captainCurrentLocation!.longitude);
  //     lookForCaptain(pickupPos: startPosition, destPos: endPosition, wynkid: wynkid!);
  //     saveUserLocation(wynkId: prefs.getString('Origwynkid')!, userCoordinates: userCoord);
  //     });
  // }

  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
    mapLocations();
    // getCaptainCurrLocation(context);
  }
  double? devWidth;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  BitmapDescriptor? originBitmap;
  BitmapDescriptor? destBitmap;
  BitmapDescriptor? currentLocatBitmap;

  double minEx = 0.1;
  LatLng? userCurLocat;
  double? rotation;
  List<ChatTile> messages = [];
  Icon icon = Icon(Icons.keyboard_arrow_down);
  Circle? circle;
  @override
  Widget build(BuildContext context) {

    circle = Circle(
      zIndex: 20,
      strokeWidth: 0,
      fillColor: kBlueTint.withOpacity(0.5),
      circleId: CircleId('current'),
      radius: 20,
      center: capCurrLocat??context.read<CaptainDetails>().captainLocation!,
    );
    curLocat=Marker(
        zIndex: 30,
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'You are here'),
        icon: BitmapDescriptor.fromBytes(context.read<FirstData>().curMarker2!),
        position: capCurrLocat??context.read<CaptainDetails>().captainLocation!,
        rotation: rotation??0
    );
    origin=Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'origin'),
        icon:context.read<FirstData>().startMarker?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: context.read<CaptainDetails>().captainLocation!);
    destination=Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: context.read<FirstData>().destMarker??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: startPos.target,

    );
    devWidth=MediaQuery.of(context).size.width;
    List<Marker> markers = [
      if(origin!=null)origin!,
      if(destination!=null)destination!,
      if(curLocat!=null)curLocat!
    ];
    return WillPopScope(
      onWillPop: ()async{
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
                  child: Text('Are you sure you want to cancel?',
                    style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                ),
                GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                    Navigator.pop(context);
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
                      child: Text('Yes, Cancel trip',
                          style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
                    ),
                  ),),
                GestureDetector(
                  onTap: (){Navigator.pop(context);},
                  child: Container(
                    margin: EdgeInsets.only(top:10.h),
                    width: MediaQuery.of(context).size.width,
                    height: 51.h,
                    decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text('No, Back to trip',
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                    ),
                  ),)
              ],
            ),
          );
        });return false;},
      child: Scaffold(
        key: _key,
        drawer:  Drawer(
          width: 250.w,
          child: DrawerWidget(),
        ),
        resizeToAvoidBottomInset: false,
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
            circles: {
              if(circle!=null)circle!
            },
            markers: markers.map((e) => e).toSet(),
            onMapCreated: GMapCont,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition : startPos,
          ),
          Visibility(
            visible: context.watch<FirstData>().showTopbar!,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 69.h),
              padding: EdgeInsets.only(left: 12.w,right: 16.w,),
              height: 61.h,
              width: devWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(context),
                  Container(
                    width: 241.w,
                    height: 46.h,
                    color: const Color(0xffF4F4F9),
                    child:  TextField(
                      cursorColor: kBlue,
                      decoration: InputDecoration(
                          hintText: navScreenController.text,
                          contentPadding: EdgeInsets.all(13),
                          border: InputBorder.none),
                    ),
                  ),IconButton(onPressed: ()async{
                    }, icon:  Icon(Icons.add))
                ],),
            ),
          ),
          Visibility(
              visible:context.watch<FirstData>().showBackbutton!,
              child:
              Container(
                margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 69.h),
                child:Container(height: 36.h,width: 36.h,
                  decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: GestureDetector(
                    child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30.w,),
                    onTap: () async{
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
                                child: Text('Are you sure you want to cancel?',
                                  style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                              ),
                              GestureDetector(
                                onTap:(){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
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
                                    child: Text('Yes, Cancel trip',
                                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
                                  ),
                                ),),
                              GestureDetector(
                                onTap: (){Navigator.pop(context);},
                                child: Container(
                                  margin: EdgeInsets.only(top:10.h),
                                  width: MediaQuery.of(context).size.width,
                                  height: 51.h,
                                  decoration: BoxDecoration(
                                    color: kBlue,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text('No, Back to trip',
                                      style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                  ),
                                ),)
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ) ,)
          ),
          DraggableScrollableSheet(
              controller: capFoundCont,
              maxChildSize: 0.8,
              initialChildSize: 0.4,
              minChildSize: minChildSize,
              builder: (context, scrollController1) {
                if(firstNavCont.size > 0.3){icon = Icon(Icons.keyboard_arrow_down);}
                else{icon = Icon(Icons.keyboard_arrow_up);}
                return DriverFound();
              })
        ],) ,),
    );
  }
}
