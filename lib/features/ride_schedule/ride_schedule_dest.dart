import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/models/directions.dart';
import '../../utilities/widgets.dart';
import '../firebase/ride_schedule.dart';
import 'my_bookings.dart';
class RideSchDestination extends StatefulWidget {
  @override
  _RideSchDestinationState createState() => _RideSchDestinationState();
}

class _RideSchDestinationState extends State<RideSchDestination> {
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    endFocusNode.dispose();
    startFocusNode.dispose();
    originFieldController.clear();
    destFieldController.clear();
  }
  var userPImage;
  @override
  void initState() {
    originFieldController.text= context.read<RideBooking>().pickupPlace!;
    startFocusNode=FocusNode();
    endFocusNode=FocusNode();
    initSharedPref();
    // TODO: implement initState
    super.initState();

    String apikey=apiKey;
    googlePlace=GooglePlace(apikey);String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions = [];
  void autoCompleteSearch(String value)async{
    var result = await googlePlace.autocomplete.get(value,components: [Component('country', 'ng')]);
    if(result!=null && result.predictions != null && mounted){
      print(result.predictions!.first.description);
      setState(() {
        predictions=result.predictions!;
      });
    }
  }
  GoogleMapController? _googleMapController;
  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
  }
  DetailsResult? startPosition;
  DetailsResult? endPosition;
  late FocusNode startFocusNode;
  late FocusNode endFocusNode;
  Timer? debouce;
  Marker? origin;
  Marker? destination;
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).autofocus(endFocusNode);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 36.w,right: 36.w,top: 15.h),
          child: Column(children: [
            SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('lib/assets/images/rides/cancel1.png',width: 33.w,height: 33.w,),
                    SizedBox(width:20.w,),
                    Text('Enter Destination',style: TextStyle(fontSize: 18.sp),),

                  ],)),
            Container(
              height: 51.h,
              width: MediaQuery.of(context).size.width,
              margin:EdgeInsets.only(top: 27.h),
              color: Color(0xffF4F4F9),
              child: Row(
                children: [
                  Container(child: Image.asset('lib/assets/images/rides/schedule_date.png',height: 19.sp,width: 19.sp,),
                    padding:EdgeInsets.symmetric(horizontal: 21.w,vertical: 16.h) ,
                  ),
                  Text( context.read<RideBooking>().pickupTime =='null'?
                  'Pickup date or time not set':'${context.read<RideBooking>().pickupDate}, ${context.read<RideBooking>().pickupTime}')
                ],
              ),
            ),
            Container(
              height: 51.h,
              width: MediaQuery.of(context).size.width,
              margin:EdgeInsets.only(top: 27.h),
              color: Color(0xffF4F4F9),
              child: Row(
                children: [
                  Container(child: Image.asset('lib/assets/images/origin_donut.png',height: 19.sp,width: 19.sp,),
                    padding:EdgeInsets.symmetric(horizontal: 21.w,vertical: 16.h) ,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if(debouce?.isActive??false) debouce!.cancel();
                        debouce=Timer(Duration(milliseconds:100),(){
                          if(value.isNotEmpty){
                            autoCompleteSearch(value);
                          }else{
                            setState(() {
                              predictions=[];
                              startPosition=null;
                            });
                          }
                        });
                      },
                      focusNode: startFocusNode,
                      controller: originFieldController,
                      decoration: InputDecoration(
                          suffixIcon: originFieldController.text.isNotEmpty?
                          IconButton(onPressed: (){
                            setState(() {
                              predictions=[];
                              originFieldController.clear();
                            });

                          }, icon: Icon(Icons.clear,color: kBlue,)):
                          null,
                          hintText: 'From where?',
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 51.h,
              width: MediaQuery.of(context).size.width,
              margin:EdgeInsets.only(top: 15.h),
              color: Color(0xffF4F4F9),
              child: Row(
                children: [

                  Container(child: Image.asset('lib/assets/images/dest_donut.png',height: 19.sp,width: 19.sp,),
                    padding:EdgeInsets.symmetric(horizontal: 21.w,vertical: 16.h) ,
                  ),
                  Expanded(
                    child: TextField(
                        focusNode: endFocusNode,
                        controller: destFieldController,
                        decoration:  InputDecoration(
                            suffixIcon: destFieldController.text.isNotEmpty?
                            IconButton(onPressed: (){
                              setState(() {
                                predictions=[];
                                destFieldController.clear();
                              });

                            }, icon: Icon(Icons.clear,color: kBlue,)):null,
                            hintText: 'Enter Destination',
                            border: InputBorder.none),
                        onChanged: (value) {
                          if(debouce?.isActive??false) debouce!.cancel();
                          debouce=Timer(Duration(milliseconds:100),(){
                            if(value.isNotEmpty){
                              autoCompleteSearch(value);
                            }else{
                              setState(() {
                                predictions=[];
                                endPosition=null;
                              });
                            }
                          });
                        }
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 181.h,
                margin:EdgeInsets.only(top: 46.h),
                child:  ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: Icon(Icons.history),
                        title: Text(predictions[index].description.toString()),
                        onTap: ()async{
                          final placeId = predictions[index].placeId;
                          final details = await googlePlace.details.get(placeId!);
                          if(details!=null && details.result != null && mounted){
                            if(startFocusNode.hasFocus){
                              setState(() {
                                startPosition = details.result;
                                originFieldController.text = details.result!.name!;
                                context.read<RideBooking>().savePickupPlace(startPosition!.name!);
                                context.read<RideBooking>().savePickupPos(
                                  LatLng(startPosition!.geometry!.location!.lat!, startPosition!.geometry!.location!.lng!)
                                );
                                predictions=[];
                                FocusScope.of(context).autofocus(endFocusNode);
                              });
                            }
                            else{
                              setState(() {
                                endPosition = details.result;
                                destFieldController.text = details.result!.name!;
                                context.read<RideBooking>().saveDestPos(
                                    LatLng(endPosition!.geometry!.location!.lat!,endPosition!.geometry!.location!.lng!)
                                );
                                context.read<RideBooking>().saveDestPlace(endPosition!.name!);
                                predictions=[];
                              });

                            }
                            if(originFieldController.text != null && startPosition == null && endPosition != null){
                              spinner(context);
                              predictions=[];

                              Position position = await determinePosition(context);
                              LatLng userCoord = LatLng(position.latitude, position.longitude);
                              print(userCoord);
                              Navigator.pop(context);
                              rideScheduleConfBS(context);
                            }
                            if(startPosition!=null && endPosition!=null && originFieldController.text != null){
                              Navigator.pop(context);
                              predictions=[];
                              // final direct=await DirectionsRepo().getDirections(origin: origin!.position, destination: destination!.position);
                              // setState(() {
                              //   _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,100.w));
                              //   info=direct;
                              // });
                              Navigator.pop(context);
                              rideScheduleConfBS(context);
                            }
                          }
                        } ,
                      );
                    }
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: ()async{
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  //     NavScreen(
                  //       startPosition: startPosition,
                  //       endPosition: endPosition,
                  //       wynkid: prefs.getString('Origwynkid'),)));
                  Navigator.pushNamed(context, '/RideDestination');
                },
                child: Container(
                  width: 160.w,
                  height: 61.h,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Container(
                        width: 160.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(25.h)
                        ),
                        child: Row(
                          children: [Icon(Icons.history),Text('Ride Now',style: TextStyle(fontSize: 13.sp),),],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),),
                      Positioned(
                        left: 124.w,
                        bottom: 39.h,
                        child:Image.asset('lib/assets/images/rideSchedule.png',width: 22.w,height: 22.w,),),
                    ],
                  ),
                ),
              ),
            ),
          ],),
        ),
      ),
    );
  }
  Future rideScheduleConfBS(BuildContext context){
    return showModalBottomSheet(
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){return
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        width: 391.w,
        height: 324.h,
        padding: EdgeInsets.only(top: 15.h,left:36.w,right:36.w),
        child: Column(children: [
          Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 6.h,),
          SizedBox(height: 30.h,),
          Text('Scheduled Pickup Details',style: TextStyle(fontSize: 18.sp),),
          SizedBox(height: 15.h,),
          Text('Pickup : ${originFieldController.text}'),
          SizedBox(height: 15.h,),
          Text('Destination: ${destFieldController.text}'),
          SizedBox(height: 15.h,),
          Text('Date : ${ context.read<RideBooking>().pickupDate}'),
          SizedBox(height: 15.h,),
          Text('Time : ${ context.read<RideBooking>().pickupTime}'),
          SizedBox(height: 20.h,),
          SizedBox(
            height: 51.h,
            width: double.infinity,
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                  primary: kBlue),
              onPressed: ()async{
                Navigator.pop(context);
                bookingSuccessful(context);              },
              child: Text('Confirm Details',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],),
      );});

  }
  Future bookingSuccessful(BuildContext context){
    return showModalBottomSheet(
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){return
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        width: 391.w,
        height: 324.h,
        padding: EdgeInsets.only(top: 15.h,left:36.w,right:36.w),
        child: Column(children: [
          Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 6.h,),
          Flexible(child: SizedBox(height: 30.h,)),
          Text('Booking Successful',style: TextStyle(fontSize: 18.sp),),
          SizedBox(height: 15.h,),
          Container(
              width: 214.w,
              child: Text(textAlign: TextAlign.center,'Hey ${ context.watch<FirstData>().user}, your scheduled ride has been booked, you’ll be assigned a Captain 10 mins before your pickup time.',style: TextStyle(fontSize: 12.sp),)),
          SizedBox(height: 15.h,),
          Flexible(child: Image.asset('lib/assets/images/rides/economy.png',width: 181.w,height: 98.h,)),
          SizedBox(
            height: 51.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue),
              onPressed: ()async{
                showDialog(context: context, builder: (context){
                  return SpinKitCircle(color: kYellow,);
                });
                await SaveBooking(
                    context.read<RideBooking>().destPlace, context.read<RideBooking>().pickupDate,
                    context.read<RideBooking>().pickupTime, context.read<RideBooking>().pickupPos,
                    context.read<RideBooking>().destPos);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const MyBookingsMVP()
                ));

              },
              child: Text('Go to bookings',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],),
      );});

  }
}
