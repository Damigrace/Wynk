import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/ride/nav_screen.dart';
import 'package:untitled/utilities/constants/colors.dart';

import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/models/directions.dart';
class RideDestination extends StatefulWidget {
   RideDestination({Key? key,this.userLocation}) : super(key: key);
   String? userLocation;
  @override
  _RideDestinationState createState() => _RideDestinationState();
}

class _RideDestinationState extends State<RideDestination> {
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
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
    originFieldController.text= widget.userLocation??'Your location';
    startFocusNode=FocusNode();
    endFocusNode=FocusNode();
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String apikey=apiKey;
    googlePlace=GooglePlace(apikey);
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  late GooglePlace googlePlace;

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
  List<AutocompletePrediction> predictions = [];
  void autoCompleteSearch(String value)async{
    var result = await googlePlace.autocomplete.get(value);
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
      key: _key,
      drawer:  Drawer(
        width: 250.w,
        child: wynkDrawer(),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 36.w,right: 36.w,top: 15.h),
          child: Column(children: [
            SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Enter Destination',style: TextStyle(fontSize: 18.sp),),
                    SizedBox(width:46.w,),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                        onTap:  () { _key.currentState!.openDrawer();},
                        child: Image.asset('lib/assets/menu.webp'),
                      ),
                    ),
                  ],)),
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

                  Container(child: Image.asset('lib/assets/images/destination_donut.png',height: 19.sp,width: 19.sp,),
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
                            hintText: 'Where to?',
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

            Container(
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
                            predictions=[];
                            FocusScope.of(context).nextFocus();
                          });
                        }
                        else{
                          setState(() {
                            endPosition = details.result;
                            destFieldController.text = details.result!.name!;
                            predictions=[];
                          });

                        }
                        if(endPosition!=null ){
                          predictions=[];

                          // final direct=await DirectionsRepo().getDirections(origin: origin!.position, destination: destination!.position);
                          // setState(() {
                          //   _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,100.w));
                          //   info=direct;
                          // });
                          FocusScope.of(context).dispose();
                          print('button2');
                          Future.delayed(Duration(seconds: 5));
                          Position position = await determinePosition(context);
                          LatLng userCoord = LatLng(position.latitude, position.longitude);
                          print(userCoord);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          saveUserLocation(wynkId: prefs.getString('Origwynkid')!, userCoordinates: userCoord);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              NavScreen(userLocation: userCoord,endPosition: endPosition,wynkid: prefs.getString('Origwynkid'))
                          ));
                        }
                        if(startPosition!=null && endPosition!=null ){
                          predictions=[];
                          // final direct=await DirectionsRepo().getDirections(origin: origin!.position, destination: destination!.position);
                          // setState(() {
                          //   _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,100.w));
                          //   info=direct;
                          // });
                          FocusScope.of(context).dispose();
                          print('button1');

                            Future.delayed(Duration(seconds: 5));
                            Position position = await determinePosition(context);
                            LatLng userCoord = LatLng(position.latitude, position.longitude);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                              saveUserLocation(wynkId: prefs.getString('Origwynkid')!, userCoordinates: userCoord);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                           NavScreen(startPosition: startPosition,endPosition: endPosition,wynkid: prefs.getString('Origwynkid'),)
                          ));
                        }
                      }
                    } ,
                  );
                }
                ),
              )
          ],),
        ),
      ),
    );
  }
}
