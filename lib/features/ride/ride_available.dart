
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:location/location.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wynk/features/registration_feature/ride_online_map.dart';
import 'package:wynk/features/ride/patron_ride_commence.dart';
import 'captain_trip_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/controllers.dart';
import 'package:wynk/features/landing_pages/captain_home.dart';
import 'package:wynk/features/landing_pages/captain_online.dart';
import 'package:wynk/features/ride/ride_destination.dart';
import 'package:wynk/features/ride/ride_started.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/models/directions.dart';
import 'package:wynk/utilities/models/directions_model.dart';
import 'package:wynk/utilities/widgets.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
class RiderAvailable extends StatefulWidget {
  @override
  State<RiderAvailable> createState() => _RiderAvailableState();
}

class _RiderAvailableState extends State<RiderAvailable> {
  String? tripPin;
  int? seconds;
  int? minutes;
  bool? timeOut;
  Timer? timers;
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
    _googleMapController?.dispose();
    locationSubscription?.cancel();
    super.dispose();

  }
  void onlineStat(int stat)async{
    final pos = await determinePosition(context);
    onlineStatus(stat, LatLng(pos.latitude, pos.longitude));
  }
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 1), (){
      //Navigator.pop(context);
      //TODO: Pop out existing mBS before proceeding
      mBS(context);});
  }
  bool riderArrived = false;
  Future mBS(BuildContext context){
    String pickup = context.read<RideDetails>().pickUp!;
    String destination = context.read<RideDetails>().destination!;
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return Container(
        height: 410.h,
        width:devWidth ,
        decoration: const BoxDecoration(
            color: kBlue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        padding: EdgeInsets.only(top: 6.h),
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

                                      child: Text('From:',style: TextStyle(color: Colors.white,fontSize: 21.sp),))),
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
                                        content: Text(destination),
                                      );
                                    });
                                  },
                                  child: Text(destination,
                                    style: TextStyle(color: Colors.white,fontSize: 18.sp),textAlign: TextAlign.start,
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
                    padding:  EdgeInsets.only(top: 16.h,right: 15.w),
                    child: Column(
                      children: [
                        SizedBox(
                            width: 60.w,
                            height: 60.h,
                            child: CircleAvatar(backgroundImage:
                            NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<RideDetails>().patronWynkid}.png'),
                            ),),
                        SizedBox(height: 10.h,),
                        FittedBox(child: Text('${context.watch<RideDetails>().riderName}',style: TextStyle(color: Colors.white,fontSize: 14.sp)))
                      ],
                    ),
                  ))
            ],),
            Container(
              margin: EdgeInsets.only(left: 15.w,top: 6.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Text('PRICE ESTIMATE',style: TextStyle(color: Colors.grey,fontSize: 12.sp),),
                  Text('₦${context.watch<RideDetails>().fair} - ₦${context.watch<RideDetails>().upperFair}',
                      style: TextStyle(color: Colors.white,fontSize: 28.sp))
                ],),),
            Flexible(
              child: Container(
                margin:  EdgeInsets.only(top: 8.h),
                width: devWidth,
                padding:  EdgeInsets.only(top: 20.h,bottom: 20.h),
                decoration: const BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  GestureDetector(
                    onTap: ()async{
                      showDialog(context: context, builder: (context){
                        return SpinKitCircle(color: kYellow,);
                      });
                     final res = await updateRideInfo(
                          wynkid: context.read<FirstData>().uniqueId!,
                          code: context.read<RideDetails>().rideCode!,
                          currentPos: userCurLocat??LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!),
                         rideStat: 4);
                     showToast(res!['errorMessage'].toString());
                      Navigator.pop(context);
                      Navigator.pop(context);
                      disableNotif(rideId: context.read<RideDetails>().rideId!, wynkid: context.read<FirstData>().uniqueId!);
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
                    onTap: ()async{
                      showDialog(context: context, builder: (context){
                        return SpinKitCircle(color: kYellow,);
                      });
                      final res = await updateRideInfo(
                          wynkid: context.read<FirstData>().uniqueId!,
                          code: context.read<RideDetails>().rideCode!,
                          currentPos: userCurLocat??LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!),
                          rideStat: 3);
                      showToast(res!['errorMessage'].toString());
                      Navigator.pop(context);
                      Navigator.pop(context);
                      disableNotif(rideId: context.read<RideDetails>().rideId!, wynkid: context.read<FirstData>().uniqueId!);
                      onlineStat(0);
                      context.read<FirstData>().saveCapOnlineStat(false);
                      Navigator.pushReplacementNamed(
                          context, '/CaptainOnline');
                    },
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
    String pickup = context.read<RideDetails>().pickUp!;
    String destination = context.read<RideDetails>().destination!;
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return Container(
        height: 385.h,
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
                                        content: Text(destination),
                                      );
                                    });
                                  },
                                  child: Text(destination,
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
                    padding:  EdgeInsets.only(top: 16.h,right: 15.w),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 60.w,
                          height: 60.h,
                          child: CircleAvatar(backgroundImage:
                          NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<RideDetails>().patronWynkid}.png'),
                          ),),
                        SizedBox(height: 10.h,),
                        FittedBox(child: Text('${context.watch<RideDetails>().riderName}',style: TextStyle(color: Colors.white,fontSize: 14.sp)))
                      ],
                    ),
                  ))
            ],),
             Flexible(child: SizedBox(height: 42.h,)),
            Container(
            child:  Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: kYellow,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  width: devWidth!,
                  height: 160.h,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 35.h,
                        child: Container(
                          width: devWidth,
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
                                    showDialog(context: context, builder: (context){
                                      return SpinKitCircle(color: kYellow,);
                                    });
                                    final pos = await determinePosition(context);
                                    print('arrived2');
                                    final res = await updateRideInfo(
                                        wynkid: context.read<FirstData>().uniqueId!,
                                        code: context.read<RideDetails>().rideCode!,
                                      currentPos: LatLng(pos.latitude, pos.longitude),
                                        rideStat: 7);
                                    print('arrived3');
                                    showToast(res!['errorMessage']..toString());
                                    Navigator.pop(context);
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
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    width: devWidth!,
                    height: 81.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Flexible(child: Image.asset('lib/assets/images/ios_call.png',height: 52.w,width: 52.w,)),
                        SizedBox(width: 9.w,),
                        Flexible(child: Image.asset('lib/assets/images/ios_message.png',height: 52.w,width: 52.w,)),
                        SizedBox(width: 9.w,),
                        Image.asset('lib/assets/images/call_cancel.png',height: 52.w,width: 52.w,)

                      ],),
                  ),
                )
              ],
            ),),],),);
    });
  }
  Future tripSummary(BuildContext context){
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return CaptainTripSummary();
    });
  }
  Future rideStarted(BuildContext context){
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
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
                    child: Text('Cancel this ride session?',
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
                        child: Text('Yes',
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
                        child: Text('No',
                          style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                      ),
                    ),)
                ],
              ),
            );
          });return false;},
        child: Container(
          height: 229.h,
          width:devWidth ,
          decoration: const BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
          ),
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
                        Text('${context.watch<RideDetails>().time} min ',style: TextStyle(color: Colors.white,fontSize: 30.sp),),
                        Text('${context.watch<RideDetails>().pickUp}',style: TextStyle(color: Colors.white,fontSize: 20.sp))
                      ],),),
                ),
                Expanded(
                    flex:2,
                    child: Padding(
                      padding:  EdgeInsets.only(top: 32.h,right: 40.w),
                      child: Column(
                        children: [
                          CircleAvatar(radius: 30.r,child: Icon(Icons.subdirectory_arrow_right_rounded),),
                          SizedBox(height: 5.h,),
                          FittedBox(child: Text('${context.watch<RideDetails>().riderName}',style: TextStyle(color: Colors.white,fontSize: 14.sp)))                        ],
                      ),
                    ))
              ],),
              SizedBox(height: 40.h,),
              Flexible(
                child: Container(
                  decoration: const BoxDecoration(
                      color: kYellow,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  width: devWidth!,
                  height: 94.h,
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
                            showDialog(context: context, builder: (context){
                              return SpinKitCircle(color: kYellow,);
                            });
                            final pos = await determinePosition(context);
                            final res = await updateRideInfo(
                                wynkid: context.read<FirstData>().uniqueId!,
                                code: context.read<RideDetails>().rideCode!,
                              currentPos: LatLng(pos.latitude, pos.longitude),
                                rideStat: 9);
                            showToast(res!['errorMessage'].toString());
                            Navigator.pop(context);
                            Navigator.pop(context);
                            tripSummary(context);
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
              ),
            ],),),
      );
    });
  }
  Future startRideMBS(BuildContext context){
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
      enableDrag: false,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return TweenAnimationBuilder<Duration>(
          tween: Tween(begin: Duration(minutes:1 ),end: Duration.zero),
          duration:Duration(minutes:1 ),
          onEnd: ()async{
            riderArrived == false?
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
                      child: Text('Rider has exhausted his waiting period',
                        style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
                    ),
                    GestureDetector(
                      onTap:()async{
                        Navigator.pop(context);
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
                                  child: Text('Are you sure you want to cancel ride?',
                                    style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
                                ),
                                GestureDetector(
                                  onTap:(){
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context)=>
                                    const CaptainHome()));
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
                                      child: Text('YES CANCEL',
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
                                      child: Text('Continue ride',
                                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                    ),
                                  ),)
                              ],
                            ),
                          );
                        });
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
                          child: Text('Cancel Ride',
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
                          child: Text('Continue waiting',
                            style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                        ),
                      ),)
                  ],
                ),
              );
            }):{};
          },
          builder: (context,value, child){
            final min = value.inMinutes;
            final sec = value.inSeconds % 60;
            return Container(
              height: 309.h,
              width:devWidth ,
              decoration: const BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text('${min}min ${sec}s',style: TextStyle(color: Colors.white,fontSize: 30.sp),),
                            Text('Waiting Time',style: TextStyle(color: Colors.white,fontSize: 20.sp))
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
                              FittedBox(child: Text('${context.watch<RideDetails>().riderName}',style: TextStyle(color: Colors.white,fontSize: 14.sp)))                            ],
                          ),
                        ))
                  ],),
                  Flexible(child: SizedBox(height: 42.h,)),
                  Container(
                    child:  Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: kYellow,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          width: devWidth!,
                          height: 160.h,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 35.h,
                                child: Container(
                                  width: devWidth,
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
                                            riderArrived = true;
                                            context.read<FirstData>().backButton(false);
                                            showDialog(context: context, builder: (context){
                                              return SpinKitCircle(color: kYellow,);
                                            });
                                            final pos = await determinePosition(context);
                                            Navigator.pop(context);
                                            await showDialog(
                                                barrierDismissible: false,
                                                context: context, builder: (context){
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    child: Icon(Icons.cancel,color: Colors.white,size: 42.sp,),
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      },
                                                  ),
                                                 AlertDialog(
                                                     contentPadding: EdgeInsets.all(30.w),
                                                     shape:  RoundedRectangleBorder(
                                                         borderRadius: BorderRadius.circular(18)
                                                     ),
                                                     content: Container(
                                                       width: 264.w,
                                                       height:241.h,
                                                       child: Column(
                                                         mainAxisSize: MainAxisSize.min,
                                                         children: [
                                                           SizedBox(
                                                             width: 170.w,
                                                             child: Text('Enter trip PIN',
                                                               style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
                                                           ),
                                                           SizedBox(height: 13.h,),
                                                           Text('Please ask Patron for their PIN',
                                                             style: TextStyle(fontSize: 13.sp),textAlign: TextAlign.center,),
                                                           Align(
                                                             alignment: Alignment.center,
                                                             child: Container(
                                                               margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
                                                               height: 61.h,
                                                               width: 260.w,
                                                               decoration:  BoxDecoration(
                                                                 borderRadius: BorderRadius.circular(7),),
                                                               child: PinCodeTextField(
                                                                 showCursor: true,
                                                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                 autoUnfocus: true,
                                                                 autoDisposeControllers: false,
                                                                 keyboardType: TextInputType.number,
                                                                 onChanged: (v){},
                                                                 autoFocus: true,
                                                                 length: 4,
                                                                 obscureText: true,
                                                                 animationType: AnimationType.fade,
                                                                 pinTheme: PinTheme(
                                                                   activeFillColor: kWhite,
                                                                   inactiveFillColor: kWhite,
                                                                   selectedFillColor: kWhite,
                                                                   activeColor: kGrey1,
                                                                   inactiveColor: kGrey1,
                                                                   selectedColor: kGrey1,
                                                                   shape: PinCodeFieldShape.box,
                                                                   borderRadius: BorderRadius.circular(5),
                                                                   fieldHeight: 61.h,
                                                                   fieldWidth: 51.w,
                                                                 ),
                                                                 animationDuration: Duration(milliseconds: 300),
                                                                 controller: tripPinController,
                                                                 onCompleted: (v) async{
                                                                   showDialog(context: context, builder: (context){
                                                                     return SpinKitCircle(color: kYellow,);
                                                                   });
                                                                   tripPin=v;
                                                                  final res = await tripStarted(otp: tripPin!);
                                                                   if(res!['statusCode'] == 200){
                                                                     updateRideInfo(
                                                                         wynkid: context.read<FirstData>().uniqueId!,
                                                                         code: context.read<RideDetails>().rideCode!,
                                                                         currentPos: LatLng(pos.latitude, pos.longitude),
                                                                         rideStat: 8);
                                                                     Navigator.pop(context);
                                                                     Navigator.pop(context);
                                                                     Navigator.push(
                                                                           context,
                                                                           MaterialPageRoute(
                                                                               builder: (context) =>
                                                                                   CaptainRideStarted()));
                                                                     tripPinController.clear();
                                                                   }

                                                                   else{
                                                                     showToast(res['errorMessage']);
                                                                     Navigator.pop(context);
                                                                     tripPinController.clear();
                                                                   }
                                                                 },
                                                                 beforeTextPaste: (text) {
                                                                   print("Allowing to paste $text");
                                                                   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                                   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                                   return true;
                                                                 }, appContext: context,
                                                               ),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   )
                                                ],
                                              );
                                            });

                                          },
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
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),
                            width: devWidth!,
                            height: 81.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Flexible(child: Image.asset('lib/assets/images/ios_call.png',height: 52.w,width: 52.w,)),
                                SizedBox(width: 9.w,),
                                Flexible(child: Image.asset('lib/assets/images/ios_message.png',height: 52.w,width: 52.w,)),
                                SizedBox(width: 9.w,),
                                Image.asset('lib/assets/images/call_cancel.png',height: 52.w,width: 52.w,)

                              ],),
                          ),
                        )
                      ],
                    ),),
                ],),);
          }
      );
    });
  }
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  Location location = Location();
  LatLng? userCurLocat;
  double? rotation;
  StreamSubscription?  locationSubscription;
  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
    mapLocations();
    locationSubscription = location.onLocationChanged.listen((event) {
      setState(() {
        userCurLocat = LatLng(event.latitude!, event.longitude!);
        rotation = event.heading;
      });
      _googleMapController?.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
            tilt: 50,
              target: LatLng(event.latitude!,event.longitude!),
              zoom: 16))
      );
    });
  }
  late LatLng position;
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
  mapLocations()async{
    final direct = await DirectionsRepo().getDirections(
        origin:LatLng(context.read<FirstData>().lat!, context.read<FirstData>().long!),
        destination: context.read<RideDetails>().pickupPos!);
    setState(() {
      _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
      info=direct;
      totalDuration = info?.totalDuration;
    });
  }

  List<Marker> markers = [];

   LatLng? start;
  LatLng? end;
  @override
  Widget build(BuildContext context) {
    origin=Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'Origin'),
        icon:context.read<FirstData>().startMarker?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng(context.read<FirstData>().lat!, context.read<FirstData>().long!),
    );
    destination=Marker(
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: context.read<FirstData>().destMarker??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position:context.read<RideDetails>().pickupPos!
    );
    devWidth=MediaQuery.of(context).size.width;
    devHeigth=MediaQuery.of(context).size.height;
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 7.5,
        target: LatLng(7.1091,5.1158));
    Set <Marker> mark = {
      if(origin!=null)origin!,
      if(destination!=null)destination!,
    };
    markers.addAll(mark);
    return Scaffold(
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
            ),
          },
          markers: markers.map((e) => e).toSet(),
          onMapCreated: GMapCont,
          myLocationEnabled: false,
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
              height: 100.h,
              width: devWidth,
              child: GestureDetector(
                onTap: (){mBS(context);},
                child:Container(
                  decoration: const BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  child: Center(child: Container(
                      decoration:  BoxDecoration(
                          color: kYellow,
                          borderRadius: BorderRadius.circular(25.h)
                      ),
                      width: 200.w,height: 50.h,
                      child: Center(child: Text('Show rider details',style: TextStyle(color: Colors.white,fontSize: 18.sp),)))),)
        ),
            ))
      ],) ,);
  }
}

//SizedBox(
//                           height: 50.h,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Flexible(
//                                   flex: 2,
//                                   child: Container(
//                                       width: 1000,
//                                       height: 50.h,
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
//                                         color: kYellow,
//                                       ),
//
//                                       child: Text('From:',style: TextStyle(color: Colors.white,fontSize: 21.sp),))),
//                               SizedBox(width: 7.w,),
//                               Flexible(
//                                 flex: 6,
//                                 child: GestureDetector(
//                                   onTap: (){
//                                     showDialog(context: context, builder: (context){
//                                       return AlertDialog(
//                                         title: Text('Pick Up :'),
//                                         content: Text(pickup),
//                                       );
//                                     });
//
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: kBlue,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
//                                         border: Border.all(color: kYellow)
//                                     ),
//                                     child: Text(pickup,
//                                       style: TextStyle(color: Colors.white,fontSize: 20.sp),textAlign: TextAlign.start,
//                                       overflow: TextOverflow.ellipsis,maxLines: 2,),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )),
//                       SizedBox(height: 15,),
//                       SizedBox(
//                           height: 50.h,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Flexible(
//                                   flex: 2,
//                                   child: Container(
//                                       alignment: Alignment.center,
//                                       height: 50.h,
//                                       width: 1000,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
//                                         color: kYellow,
//                                       ),
//                                       child: Text('To:',style: TextStyle(color: Colors.white,fontSize: 21.sp),))),
//                               SizedBox(width: 7.w,),
//                               Flexible(
//                                 flex: 6,
//                                 child: GestureDetector(
//                                   onTap: (){
//                                     showDialog(context: context, builder: (context){
//                                       return AlertDialog(
//                                         title: Text('Destination:'),
//                                         content: Text(destination),
//                                       );
//                                     });
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: kBlue,
//                                       border: Border.all(color: kYellow),
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
//                                     ),
//                                     child: Text(destination,
//                                       style: TextStyle(color: Colors.white,fontSize: 20.sp),textAlign: TextAlign.start,
//                                       overflow: TextOverflow.ellipsis,maxLines: 2,),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ))