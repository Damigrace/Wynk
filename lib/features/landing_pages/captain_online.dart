
import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/controllers.dart';
import 'package:wynk/features/landing_pages/captain_home.dart';
import 'package:wynk/features/landing_pages/home_main14.dart';
import 'package:wynk/features/payments/trip_page.dart';
import 'package:wynk/features/registration_feature/captain_f_registration.dart';
import 'package:wynk/features/ride/earnings_page.dart';
import 'package:wynk/features/ride/ride_available.dart';
import 'package:wynk/features/ride/ride_destination.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/models/directions.dart';
import 'package:wynk/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
import '../local_notif.dart';
class CaptainOnline extends StatefulWidget {
   CaptainOnline({Key? key}) : super(key: key);
  @override
  State<CaptainOnline> createState() => _CaptainOnlineState();
}

class _CaptainOnlineState extends State<CaptainOnline> {
  Timer? timer;
  Timer? sheetTimer;
  var userPImage;
  bool isVisible = false;
  bool is2Visible = false;
  bool hasBuiltBottomSheet = false;
  Position? pos;
  GoogleMapController? _googleMapController;
  Marker? origin;
  SharedPreferences? prefs;
  LatLng? userCurLocat;
  BitmapDescriptor? currentLocatBitmap;
  StreamSubscription<LocationData>? locationSubscription;
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  Location location = Location();
  void genIconBitMap()async{
    currentLocatBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/rides/car2.png",);
    setState(() {});
  }
  saveLocation()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   timer = Timer.periodic(const Duration(seconds: 60), (timer)async {
      Position position = await determinePosition(context);
      LatLng userCoord = LatLng(position.latitude, position.longitude);
      saveUserLocation(wynkId: prefs.getString('Origwynkid')!, userCoordinates: userCoord);
    });
  }
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  @override
  void dispose() {
    sheetTimer?.cancel();
    // TODO: implement dispose
    super.dispose();

    locationSubscription?.cancel();
    _googleMapController?.dispose();
    timer?.cancel();
  }
  @override
  void initState() {
    saveLocation();
    onlineStat(1);
    initSharedPref();
    setTimer();
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  void setTimer(){
    sheetTimer = Timer.periodic(Duration(seconds: 2), (_){
      context.read<FirstData>().changeVisibility();
    });
  }
  BitmapDescriptor? originBitmap;
  double? rotation;
  void onlineStat(int stat)async{
    final pos = await determinePosition(context);
    onlineStatus(stat, LatLng(pos.latitude, pos.longitude));
     originBitmap =  await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/originmarker.png",
    );
  }
  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
    genIconBitMap();
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
  Marker? curLocat;
  String? upperAmount;

  bool notified = false;
  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 11.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    origin=Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'You are here'),
        icon: currentLocatBitmap?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: userCurLocat??initialCameraPosition.target,
        rotation: rotation??0
    );
    void saveDetails(Map<String, dynamic> rideDetails,BuildContext context) async{
      await Future.delayed(Duration(seconds: 2));
      print('pMeans: ${rideDetails['payment_mode']}');
      String? rideCode = rideDetails['code'];
      context.read<RideDetails>().savePaymentMode(rideDetails['payment_mode']);
      Map<String, dynamic>? details = await getRideDetails(wynkid:context.read<FirstData>().uniqueId!, code:rideCode! );
      context.read<RideDetails>().saveDistance(details!['distance'] );
      context.read<RideDetails>().savePickup(details['pickup']);
      context.read<RideDetails>().savePatronWynkid(details['patron_wynkid']);
      context.read<RideDetails>().saveRideCode(rideCode);
      context.read<RideDetails>().saveRideId(rideDetails['id']);
      double val = double.parse(details['amount']);
      double val2 = val + 500;
      String amount = balanceFormatter.format(val).toString();
      String amount2 = balanceFormatter.format(val2).toString();
      context.read<RideDetails>().saveUpperFair(amount2);
      context.read<RideDetails>().saveFair(amount);
      context.read<RideDetails>().saveDestination(details['destination'] );
      context.read<RideDetails>().savePickupPos(LatLng(double.parse(details['pickup_lat']),double.parse(details['pickup_long'])) );
      context.read<RideDetails>().saveDestPos(LatLng(double.parse(details['dest_lat']),double.parse(details['dest_long'])) );
      context.read<RideDetails>().savePickupDate(details['pick_up_date'] );
      context.read<RideDetails>().saveTime(details['minutes'] );
      context.read<RideDetails>().saveRiderName(details['patrion_name'] );

        Navigator.pushReplacementNamed(context, '/RiderAvailable');


    }
    Widget DraggabbleSS = DraggableScrollableSheet(
        controller: rideFoundCont,
        maxChildSize: 0.5,
        initialChildSize: 0.2,
        minChildSize: 0.1,
        builder: (context, scrollController2) {

          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            controller: scrollController2,
            child:
            Column(
              children: [
                Image.asset('lib/assets/images/handle.png',height: 35.h,width: 35.h,fit: BoxFit.contain,),
                SizedBox(
                    height: 71.h,
                    width: MediaQuery.of(context).size.width,
                    child: context.watch<FirstData>().visible == true?
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                        color: kYellow,
                      ),
                      height: 61.h,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TextButton(
                        onPressed: ()async{
                          onlineStat(0);
                          context.read<FirstData>().saveCapOnlineStat(false);
                          timer?.cancel();
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const CaptainHome()
                          ));
                        },
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('GO OFFLINE',style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                            const Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                          ],
                        ),
                      ),
                    ):Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                          color: kYellow,
                        ),
                        height: 61.h,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Center(child:Text('LOOKING FOR PATRON...',style: TextStyle(fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.w500),),
                        )))
                ),
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(width: 1,color: kGrey1)
                        )
                    ),
                    height: 88.h,
                    width: MediaQuery.of(context).size.width,
                    child:Stack(
                      children: [
                        Positioned(
                          child: Text('TODAY\'S EARNINGS'),
                          top: 21.h,
                          left: 25.w,),
                        Positioned(
                          top: 39.h,
                          left: 25.w,
                          child:Text('₦${context.read<FirstData>().todayEarning
                          !}',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
                          ,),
                        Positioned(
                          top: 23.h,
                          right: 25.w,
                          child:GestureDetector(
                            onTap:()async{
                              spinner(context);
                              final res = await earnings();
                              if(res['statusCode'] != 200){
                                Navigator.pop(context);
                                showSnackBar(context, res['errorMessage']);}
                                else{
                                List res1 = res['message'] as List;
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute
                                  (builder: (context) =>EarningsPage(earnings: res1,)),);
                              }

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff0f0f0f)
                                  ),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              width: 102.w,
                              height: 39.h,
                              child: Center(child: Text('Earnings')),
                            ),
                          )
                          ,),
                      ],
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(width: 1,color: kGrey1)
                      )
                  ),
                  height: 97.h,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                        child: const Text('TODAY\'S TRIPS'),
                        top: 21.h,
                        left: 25.w,),
                      Positioned(
                        top: 39.h,
                        left: 25.w,
                        child:Text(context.read<FirstData>().todayTrip!,style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
                        ,),
                      Positioned(
                        top: 23.h,
                        right: 25.w,
                        child:GestureDetector(
                          onTap: ()async{
                            spinner(context);
                            final res = await earnings();
                            if(res['statusCode'] != 200){
                              Navigator.pop(context);
                              showSnackBar(context, res['errorMessage']);}
                            else{
                            List res1 = res['message'] as List;
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute
                              (builder: (context) =>TripPage(earnings: res1,)),);}
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff0f0f0f)
                                ),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            width: 102.w,
                            height: 39.h,
                            child: Center(child: Text('History')),
                          ),
                        )
                        ,),
                    ],
                  ),
                ),
                Container(
                  height: 150.h,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                        child: const Text('AVERAGE RATING'),
                        top: 21.h,
                        left: 25.w,),
                      Positioned(
                        top: 39.h,
                        left: 25.w,
                        child:Text(context.read<FirstData>().averageRating!,style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
                        ,),
                      Positioned(
                        top: 23.h,
                        right: 25.w,
                        child:Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff0f0f0f)
                              ),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          width: 102.w,
                          height: 39.h,
                          child: Center(child: Text('Ratings')),
                        )
                        ,),
                    ],
                  ),
                ),
              ],),
          );
        });
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          markers: {
            if(origin!=null)origin!,
          },

          onMapCreated: GMapCont,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition : initialCameraPosition,
        ),
        Positioned(
        top: 77.h,
        left: 25.w,
        child: backButton(context)),
        FutureBuilder(
        future: getNotification(wynkid: context.read<FirstData>().uniqueId!),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(!snapshot.hasData){
            return DraggabbleSS;
           }
          else{
            if(snapshot.data['statusCode'] == 200 ){
              notified == false?
              {
                NotificationService.showNotif('Wynk', 'You have a ride request'),
                notified = true
              } :{};
              sheetTimer?.cancel();
              saveDetails(snapshot.data,context);
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: kBlueTint,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  width: 150.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h,),
                      SpinKitCircle(color: kYellow,),
                      SizedBox(height: 10.h,),
                      Text('Getting Ride Details',style: TextStyle(color: Colors.white,fontSize: 18.sp),textAlign: TextAlign.center,),
                      SizedBox(height: 10.h,),
                    ],
                  ),
                ),
              );
            }
           else{
             return
               DraggabbleSS;
            }
          }

        },

        )
      ],) ,);
  }
}
