
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_place/google_place.dart' hide Location;
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
import '../local_notif.dart';
import '../modal_bottom_sheets/driver -search_mbs.dart';
class RideInProgress extends StatefulWidget {

  RideInProgress({Key? key,}) : super(key: key);

  @override
  State<RideInProgress> createState() => _RideInProgressState();
}

class _RideInProgressState extends State<RideInProgress> {
  Timer? timer;
  late CameraPosition startPos;
  late CameraPosition endPos;
  bool notified1 = false;
  void mapLocations()async{
    final direct=await DirectionsRepo().getDirections(origin: startPos.target, destination: endPos.target);
    setState(() {
      _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
      info=direct;
      totalDuration = info?.totalDuration;
    });
    payAndEndRide()async{
      print('checking if ride started');
      dynamic val = await rideStatus(rideCode: context.read<CaptainDetails>().rideCode!);

      switch(val['status_code']){

        case '9':
          {
            if(notified1 == false){
              showDialog(
                  barrierDismissible: false,
                  context: context, builder: (context){
                return Container(child:
                SpinKitCircle(
                  color: kYellow,
                ),);
              });
              NotificationService.showNotif('Wynk', 'Ride has ended. Kindly leave a comment below. Thank you.');
              timer?.cancel();
              final paymentRes = await ridePayment(
                  captainWynkId:  context.read<CaptainDetails>().capId!,
                  paymentMeans: context.read<FirstData>().paymentMeans,
                  rideCode: context.read<CaptainDetails>().rideCode!);
              if(paymentRes['status_code'] == 200){
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context,'/RideEnded');
              }
              notified1 = true;
            }
          }

          break;
      }
    }

    timer = Timer.periodic(Duration(seconds: 20), (_) async {
      payAndEndRide();
    });
  }
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  double minChildSize = 0.1;
  double minChildSize1 = 0.2;
  @override
  void dispose() {
    super.dispose();
    _googleMapController?.dispose();
    originFieldController.clear();
    locationSubscription?.cancel();
    timer?. cancel();
  }
  late GooglePlace googlePlace;
  String? totalDuration;

  @override
  void initState() {
    startPos=CameraPosition(target: context.read<FirstData>().patronCurentLocation??
        LatLng(context.read<FirstData>().startPos!.geometry!.location!.lat!,
            context.read<FirstData>().startPos!.geometry!.location!.lng!));
    endPos=CameraPosition(target: LatLng(
        context.read<FirstData>().endPos!.geometry!.location!.lat!,
        context.read<FirstData>().endPos!.geometry!.location!.lng!));

    String apikey=apiKey;
    googlePlace=GooglePlace(apikey);
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
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

  void GMapCont(GoogleMapController controller){
    context.read<FirstData>().backButton(false);
    _googleMapController=controller;
    mapLocations();
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
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  BitmapDescriptor? originBitmap;
  BitmapDescriptor? destBitmap;
  BitmapDescriptor? currentLocatBitmap;


  double minEx = 0.1;
  int groupValue=0;
  LatLng? userCurLocat;
  double? rotation;
  List<ChatTile> messages = [];
  Icon icon = Icon(Icons.keyboard_arrow_down);
  Circle? circle;
  @override
  Widget build(BuildContext context) {
    curLocat=Marker(
        zIndex: 30,
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'You are here'),
        icon: BitmapDescriptor.fromBytes(context.read<FirstData>().curMarker2!),
        position: userCurLocat??startPos.target,
        rotation: rotation??0

    );
    circle = Circle(
      strokeWidth: 10,
      zIndex: 20,
      strokeColor: kYellow,
      fillColor: kBlue,
      circleId: CircleId('current'),
      radius: 50,
      center: userCurLocat??startPos.target,
    );
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
          // GoogleMap(
          //   polylines: {
          //     if(info!=null)Polyline(
          //       polylineId: PolylineId('overview_polyline'),
          //       color: kBlue,
          //       width: 3,
          //       points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude))
          //           .toList(),
          //     )
          //   },
          //   markers: markers.map((e) => e).toSet(),
          //   circles: {
          //     circle!,
          //   },
          //   onMapCreated: GMapCont,
          //   myLocationEnabled: false,
          //   zoomControlsEnabled: false,
          //   initialCameraPosition : startPos,
          // ),
          Visibility(
              visible:context.watch<FirstData>().showBackbutton!,
              child:
              Container(
                margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 69.h),
                child:backButton(context) ,)
          ),
          DraggableScrollableSheet(
              controller: rideCommenceCont,
              maxChildSize: 0.4,
              initialChildSize: 0.382,
              minChildSize: 0.382,
              builder: (context, scrollController1) {
                return Container(
                  width: 390.w,
                  height: 322.h,
                  padding: EdgeInsets.symmetric(horizontal: 17.w),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                  ),
                  child: ListView(
                    controller: scrollController1,
                    shrinkWrap:  true,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset('lib/assets/images/handle_straight.png',width: 56.w,height: 11.h,)
                      ),
                      SizedBox(height: 24.h,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:  CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 22.h,),
                          Text("You'll arrive in ",style: TextStyle(fontSize: 18.sp),),
                          SizedBox(height: 48.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('dfdnfcjkjjff',style: TextStyle(fontSize: 10.sp),),
                                  SizedBox(height: 9.h,),
                                  Text('capId!',style: TextStyle(fontSize: 18.sp),),
                                  SizedBox(height: 22.h,),
                                  Text('Your Captain is',style: TextStyle(fontSize: 18.sp),),
                                ],),
                              Container(
                                width: 71.w,height: 81.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(child: CircleAvatar(
                                      radius: 35.w,
                                    )),
                                    Positioned(
                                        bottom: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal:3.w,vertical: 2.h ),
                                          height: 21.h,
                                          width:49.w,
                                          decoration:  BoxDecoration(
                                              color: kBlue,
                                              borderRadius:BorderRadius.circular(25)
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: RatingBarIndicator(
                                              itemBuilder: (context, index) => Icon(Icons.star,color: kYellow,),
                                              rating:2
                                              //double.parse(context.read<CaptainDetails>().capRating!
                                              ,
                                              direction: Axis.horizontal,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],),
                          Flexible(child:SizedBox(
                              height: 53.h
                          )),
                          Container(

                            height: 51.h,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kBlue
                              ),
                              onPressed: (){
                                context.read<FirstData>().topBar(false);
                                context.read<FirstData>().backButton(true);
                                // capFoundCont.jumpTo(0.2);

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('lib/assets/images/share_trip.png'),
                                  SizedBox(width: 10.w,),
                                  Text('Share Trip',style: TextStyle(fontSize: 15.sp),),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h,)
                        ],)
                    ],
                  ),
                );
              })
        ],) ,),
    );
  }
}
