
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
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../modal_bottom_sheets/driver -search_mbs.dart';
class NavScreen extends StatefulWidget {

 DetailsResult? startPosition;
 DetailsResult? endPosition;
 LatLng? userLocation;
 String? wynkid;
  NavScreen({Key? key, this.startPosition, this.endPosition,this.userLocation,this.wynkid}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {

  late CameraPosition startPos;
  late CameraPosition endPos;
  void mapLocations()async{
      final direct=await DirectionsRepo().getDirections(origin: startPos.target, destination: endPos.target);
      setState(() {
        _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
        info=direct;
        totalDuration = info?.totalDuration;
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
    destFieldController.clear();
    controller4.dispose();

  }
  late GooglePlace googlePlace;
   String? totalDuration;
  @override
  void initState() {
    context.read<FirstData>().backButton(false);
    startPos=CameraPosition(target: widget.userLocation?? LatLng(widget.startPosition!.geometry!.location!.lat!,widget.startPosition!.geometry!.location!.lng!));
    endPos=CameraPosition(target: LatLng(
      widget.endPosition!.geometry!.location!.lat!,widget.endPosition!.geometry!.location!.lng!));
    String apikey=apiKey;
    googlePlace=GooglePlace(apikey);
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  bool showTopNav = true;
  bool showBackButton = false;
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  Directions? info;
  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
    mapLocations();
    genIconBitMap();
  }
  double? devWidth;
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
  BitmapDescriptor? originBitmap;
  BitmapDescriptor? destBitmap;
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
  double minEx = 0.1;
  final controller = DraggableScrollableController();
int groupValue=0;
  List<ChatTile> messages = [];
  @override
  Widget build(BuildContext context) {

    origin=Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'Origin'),
        icon:originBitmap?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: widget.userLocation??startPos.target
    );
    destination=Marker(
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: destBitmap??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: endPos.target
    );
    devWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      drawer:  Drawer(
        width: 250.w,
        child: wynkDrawer(),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        GoogleMap(
          polylines: {
            if(info!=null)Polyline(
              polylineId: PolylineId('overview_polyline'),
              color: Colors.blue,
              width: 5,
              points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            )
          },
          markers: {
            if(origin!=null)origin!,
            if(destination!=null)destination!,
          },

          onMapCreated: GMapCont,
          myLocationEnabled: true,
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
                    decoration: InputDecoration(
                        hintText: destFieldController.text,
                        contentPadding: EdgeInsets.all(13),
                        border: InputBorder.none),
                ),
              ),
              Icon(Icons.add)
            ],),
          ),
        ),
        Visibility(
            visible:context.watch<FirstData>().showBackbutton!,
            child:
            Container(
              margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 69.h),
              child:backButton(context) ,)
            ),
        DraggableScrollableSheet(
         controller: controller,
         maxChildSize: 0.8,
           initialChildSize: 0.4,
           minChildSize: minChildSize,
           builder: (context, scrollController1) {
         return Container(
           padding: EdgeInsets.symmetric(horizontal: 17.w),
           decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
           ),
           child: SingleChildScrollView(
             physics: ClampingScrollPhysics(),
             controller: scrollController1,
             child:
           Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               SizedBox(height: 33.h,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('Choose a ride'),
                   GestureDetector(
                       onTap: (){},
                       child: CircleAvatar(radius: 12.r,child: Icon(Icons.keyboard_arrow_down,color: kBlue),backgroundColor: Color(0xffF3F3F3),))
                 ],),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   controller.jumpTo(minChildSize);
                   showModalBottomSheet(
                       barrierColor: Colors.transparent,
                     backgroundColor: Colors.transparent,
                     enableDrag: false,
                       isScrollControlled: true,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                       ),
                       context: context,
                       builder: (context){
                         return DraggableScrollableSheet(
                           maxChildSize: 0.4,
                           initialChildSize: 0.4,
                           minChildSize: 0.1,
                           builder: (BuildContext context, ScrollController scrollController) {
                           return ListView(
                             shrinkWrap: true,
                             controller: scrollController,
                             children: [
                               StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                                 return Container(
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(10)
                                   ),
                                   padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                                   child: ListView(
                                     shrinkWrap: true,
                                     children: [
                                       Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                                       SizedBox(height: 22.h,),
                                       Rides(
                                         image: 'lib/assets/images/rides/economy.png',
                                         title: 'Economy',
                                         time: '10:20 Dropoff',
                                         price: '₦ 700 - 1100', color: Color(0xffF7F7F7),),
                                       SizedBox(height: 21.h,),
                                       Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                       SizedBox(
                                         child: Container(
                                           padding: EdgeInsets.only(top: 17.h),
                                           width: double.infinity,
                                           child: Row(children: [
                                             Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                             SizedBox(width: 18.w,),
                                             SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),)),
                                             Radio<int>(activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){print(value);
                                             setState(() {
                                               groupValue=value!;
                                             });
                                             Navigator.pop(context);
                                             showModalBottomSheet(
                                                 isScrollControlled: true,
                                               backgroundColor: Colors.transparent,
                                               enableDrag: false,
                                                 barrierColor: Colors.transparent,
                                                 isDismissible: false,
                                                 shape: const RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                                 ),
                                                 context: context, builder: (context){
                                               return DraggableScrollableSheet(
                                                 controller: controller1,
                                                 maxChildSize: 0.4,
                                                 initialChildSize: 0.4,
                                                 minChildSize: minChildSize1,
                                                 builder: (BuildContext context, ScrollController scrollController) {
                                                   return ListView(
                                                     shrinkWrap: true,
                                                     physics: ClampingScrollPhysics(),
                                                     controller: scrollController,
                                                     children:[
                                                       DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/economy.png'),
                                                     ]
                                                   );
                                               },);
                                             });
                                             })
                                           ],),
                                         ),
                                       ),
                                       Container(
                                         padding: EdgeInsets.only(top: 0.h),
                                         width: double.infinity,
                                         child:
                                         Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkcash.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){print(value);
                                           setState(() {
                                             groupValue=value!;
                                           });
                                           Navigator.pop(context);
                                           showModalBottomSheet(
                                               isScrollControlled: true,
                                               backgroundColor: Colors.transparent,
                                               enableDrag: false,
                                               barrierColor: Colors.transparent,
                                               isDismissible: false,
                                               shape: const RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                               ),
                                               context: context, builder: (context){
                                             return DraggableScrollableSheet(
                                               controller: controller1,
                                               maxChildSize: 0.4,
                                               initialChildSize: 0.4,
                                               minChildSize: minChildSize1,
                                               builder: (BuildContext context, ScrollController scrollController) {
                                                 return ListView(
                                                     shrinkWrap: true,
                                                     physics: ClampingScrollPhysics(),
                                                     controller: scrollController,
                                                     children:[
                                                       DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/economy.png'),
                                                     ]
                                                 );
                                               },);
                                           });
                                           })
                                         ],),
                                       ),
                                       SizedBox(height: 18.h,),
                                     ],),);
                               },

                               ),
                             ],
                           );
                         },
                         );
                       });
                 },
                 child: Rides(
                   image: 'lib/assets/images/rides/economy.png',
                   title: 'Economy',
                   time: '10:20 Dropoff',
                   price: '₦ 700 - 1100', color: Color(0xffF7F7F7),),
               ),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                   showModalBottomSheet(
                       isScrollControlled: true,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                       ),
                       context: context,
                       builder: (context){
                         return Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                               return Container(
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10)
                                 ),
                                 padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                                 child: ListView(
                                   shrinkWrap: true,
                                   children: [
                                     Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                                     SizedBox(height: 22.h,),
                                     Rides(
                                       image: 'lib/assets/images/rides/sedan.png',
                                       title: 'Sedan',
                                       time: '10:20 Dropoff',
                                       price: '₦ 900 - 1500', color: Color(0xffF7F7F7),),
                                     SizedBox(height: 21.h,),
                                     Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                     SizedBox(
                                       child: Container(
                                         padding: EdgeInsets.only(top: 17.h),
                                         width: double.infinity,
                                         child: Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){print(value);
                                           setState(() {
                                             groupValue=value!;
                                           });
                                           Navigator.pop(context);
                                           showModalBottomSheet(
                                               shape: const RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                               ),
                                               context: context, builder: (context){
                                             return DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/sedan.png');
                                           });
                                           })
                                         ],),
                                       ),
                                     ),
                                     Container(
                                       padding: EdgeInsets.only(top: 0.h),
                                       width: double.infinity,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Image.asset('lib/assets/images/rides/wynkcash.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             print(value);
                                             setState(() {
                                               groupValue=value!;
                                             });
                                             Navigator.pop(context);
                                             showModalBottomSheet(
                                                 shape: const RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                                 ),
                                                 context: context, builder: (context){
                                               return DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/sedan.png');
                                             });
                                           })
                                         ],),
                                     ),
                                     SizedBox(height: 18.h,),
                                   ],),);
                             },

                             ),
                           ],
                         );
                       });
                 },
                 child: Rides(
                   image: 'lib/assets/images/rides/sedan.png',
                   title: 'Sedan',
                   time: '10:20 Dropoff',
                   price: '₦ 900 - 1500', color: Color(0xffF7F7F7),),
               ),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                   showModalBottomSheet(
                       isScrollControlled: true,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                       ),
                       context: context,
                       builder: (context){
                         return Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                               return Container(
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10)
                                 ),
                                 padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                                 child: ListView(
                                   shrinkWrap: true,
                                   children: [
                                     Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                                     SizedBox(height: 22.h,),
                                     Rides(
                                       image: 'lib/assets/images/rides/taxi.png',
                                       title: 'Taxi',
                                       time: '10:20 Dropoff',
                                       price: '₦ 700 - 1100', color: Colors.white,),
                                     SizedBox(height: 21.h,),
                                     Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                     SizedBox(
                                       child: Container(
                                         padding: EdgeInsets.only(top: 17.h),
                                         width: double.infinity,
                                         child: Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){print(value);
                                           setState(() {
                                             groupValue=value!;
                                           });
                                           Navigator.pop(context);
                                           showModalBottomSheet(
                                               shape: const RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                               ),
                                               context: context, builder: (context){
                                             return DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/taxi.png');
                                           });
                                           })
                                         ],),
                                       ),
                                     ),
                                     Container(
                                       padding: EdgeInsets.only(top: 0.h),
                                       width: double.infinity,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Image.asset('lib/assets/images/rides/wynkcash.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             print(value);
                                             setState(() {
                                               groupValue=value!;
                                             });
                                             Navigator.pop(context);
                                             showModalBottomSheet(
                                                 shape: const RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                                 ),
                                                 context: context, builder: (context){
                                               return DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/taxi.png');
                                             });
                                           })
                                         ],),
                                     ),
                                     SizedBox(height: 18.h,),
                                   ],),);
                             },

                             ),
                           ],
                         );
                       });
                 },
                 child: Rides(
                   image: 'lib/assets/images/rides/taxi.png',
                   title: 'Taxi',
                   time: '10:20 Dropoff',
                   price: '₦ 700 - 1100', color: Colors.white,),
               ),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                   showModalBottomSheet(
                       isScrollControlled: true,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                       ),
                       context: context,
                       builder: (context){
                         return Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                               return Container(
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10)
                                 ),
                                 padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                                 child: ListView(
                                   shrinkWrap: true,
                                   children: [
                                     Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                                     SizedBox(height: 22.h,),
                                     Rides(
                                       image: 'lib/assets/images/rides/moto.png',
                                       title: 'Moto',
                                       time: '10:20 Dropoff',
                                       price: '₦ 500 - 700', color: Colors.white,),
                                     SizedBox(height: 21.h,),
                                     Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                     SizedBox(
                                       child: Container(
                                         padding: EdgeInsets.only(top: 17.h),
                                         width: double.infinity,
                                         child: Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){print(value);
                                           setState(() {
                                             groupValue=value!;
                                           });
                                           Navigator.pop(context);
                                           showModalBottomSheet(
                                               shape: const RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                               ),
                                               context: context, builder: (context){
                                             return DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/moto.png');
                                           });
                                           })
                                         ],),
                                       ),
                                     ),
                                     Container(
                                       padding: EdgeInsets.only(top: 0.h),
                                       width: double.infinity,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Image.asset('lib/assets/images/rides/wynkcash.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),)),
                                           Radio<int>(activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             print(value);
                                             setState(() {
                                               groupValue=value!;
                                             });
                                             Navigator.pop(context);
                                             showModalBottomSheet(
                                                 shape: const RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                                 ),
                                                 context: context, builder: (context){
                                               return DriverSearch(totalDuration: totalDuration,carImage: 'lib/assets/images/rides/moto.png');
                                             });
                                           })
                                         ],),
                                     ),
                                     SizedBox(height: 18.h,),
                                   ],),);
                             },

                             ),
                           ],
                         );
                       });
                 },
                 child:Rides(
                   image: 'lib/assets/images/rides/moto.png',
                   title: 'Moto',
                   time: '10:20 Dropoff',
                   price: '₦ 500 - 700', color: Colors.white,),
               ),
             ],
           )
             ,),
          );
       })
      ],) ,);
  }
}
