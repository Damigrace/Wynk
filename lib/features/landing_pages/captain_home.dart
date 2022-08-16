
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/registration_feature/captain_f_registration.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
class CaptainHome extends StatefulWidget {
  const CaptainHome({Key? key}) : super(key: key);

  @override
  State<CaptainHome> createState() => _CaptainHomeState();
}

class _CaptainHomeState extends State<CaptainHome> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  num vaultBalance=0;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController?.dispose();

  }
  Position? pos;
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  GoogleMapController? _googleMapController;
  Marker? origin;

  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
  }
  Timer? debouce;
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

  wynkDrawer(){
    return  ListView(children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(),
            SizedBox(height: 10.h,),
            Text('₦${balanceFormatter.format(vaultBalance)}', style:TextStyle(color: Colors.green,fontSize: 18.sp),),
            Padding(
              padding:  EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.eye_slash_fill),
                  SizedBox(width: 10.w,),
                  Text( 'Vault Balance',style:TextStyle(color: Colors.black87,fontSize: 18.sp))
                ],
              ),
            ),
          ],),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        color: Colors.white54,
        child: ListView.builder(
          shrinkWrap: true,
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
  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 11.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    origin=Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: initialCameraPosition.target
    );

    return Scaffold(
      key: _key,
      drawer:  Drawer(elevation: 0,
        backgroundColor: Colors.white,
        width: 250.w,
        child: wynkDrawer(),
      ),
      body: Stack(children: [
        GoogleMap(
          markers: {
            if(origin!=null)origin!,
          },

          onMapCreated: GMapCont,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition : initialCameraPosition,
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: 61.h,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      primary: kBlue),
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                   bool? captRegStat = prefs.getBool('capRegStat');
                   if(captRegStat == true){
                     print('Captain Registered');
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
                               Container(
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10)
                                 ),
                                 padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                                 child: ListView(
                                   shrinkWrap: true,
                                   children: [
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text('Choose a ride'),
                                         GestureDetector(
                                             onTap: (){Navigator.pop(context);},
                                             child: CircleAvatar(radius: 12.r,child: Icon(Icons.keyboard_arrow_down,color: kBlue),backgroundColor: Color(0xffF3F3F3),))
                                       ],),
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
                                   ],),),
                             ],
                           );
                         });
                   }
                   else{
                     Navigator.push(
                         context, MaterialPageRoute(builder: (context) => const CaptainFRegistration()
                     ));
                   }
                  },
                  child: Text('GO ONLINE',style: TextStyle(fontSize: 15.sp),),
                ),)
          ),
        ),
        Positioned(
          top: 80.h,
          right: 28.w,
          child: GestureDetector(
            onTap:  () { _key.currentState!.openDrawer();},
            child: Image.asset('lib/assets/menu.webp'),
          ),
        ),
        UserProfileHeader(),
      ],) ,);
  }
}

