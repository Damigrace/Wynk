
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/landing_pages/captain_home.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/registration_feature/captain_f_registration.dart';
import 'package:untitled/features/ride/ride_available.dart';
import 'package:untitled/features/ride/ride_destination.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/models/directions.dart';
import 'package:untitled/utilities/models/directions_model.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
class CaptainOnline extends StatefulWidget {
  const CaptainOnline({Key? key}) : super(key: key);

  @override
  State<CaptainOnline> createState() => _CaptainOnlineState();
}

class _CaptainOnlineState extends State<CaptainOnline> {
  saveLocation()async{
    Timer.periodic(const Duration(seconds: 60), (timer)async {
      Position position = await determinePosition(context);
      LatLng userCoord = LatLng(position.latitude, position.longitude);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      saveUserLocation(wynkId: prefs.getString('Origwynkid')!, userCoordinates: userCoord);
    });
  }
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
    saveLocation();
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
  bool isVisible = false;
  bool is2Visible = false;
  bool hasBuiltBottomSheet = false;
  num earnings = 0;
  @override
  Widget build(BuildContext context) {
   // if (hasBuiltBottomSheet == false){
   //   Timer(Duration(milliseconds: 100), (){
   //     showModalBottomSheet(
   //         shape: RoundedRectangleBorder(
   //             borderRadius: BorderRadius.only(topRight:Radius.circular(10),topLeft:Radius.circular(10))
   //         ),
   //         context: context, builder: (context){
   //       return  Container(
   //         decoration: BoxDecoration(
   //             color: Colors.white,
   //             borderRadius: BorderRadius.circular(25)
   //         ),
   //         child: Column(
   //           children: [
   //             SizedBox(
   //                 height: 61.h,
   //                 width: MediaQuery.of(context).size.width,
   //                 child: ElevatedButton(
   //                   style: ElevatedButton.styleFrom(
   //                       primary: kYellow),
   //                   onPressed: ()async{
   //                     Navigator.pushReplacement(
   //                         context, MaterialPageRoute(builder: (context) => const CaptainHome()
   //                     ));
   //                   },
   //                   child: Row(mainAxisAlignment: MainAxisAlignment.center,
   //                     children: [
   //                       Text('GO OFFLINE',style: TextStyle(fontSize: 15.sp),),
   //                       Icon(Icons.keyboard_arrow_right)
   //                     ],
   //                   ),
   //                 )
   //             ),
   //             Container(
   //                 decoration: const BoxDecoration(
   //                     border: Border(
   //                         bottom: BorderSide(width: 1,color: kGrey1)
   //                     )
   //                 ),
   //                 height: 88.h,
   //                 width: MediaQuery.of(context).size.width,
   //                 child:Stack(
   //                   children: [
   //                     Positioned(
   //                       child: Text('TODAY\'S EARNINGS'),
   //                       top: 21.h,
   //                       left: 25.w,),
   //                     Positioned(
   //                       top: 39.h,
   //                       left: 25.w,
   //                       child:Text('₦${balanceFormatter.format(earnings)}',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
   //                       ,),
   //                     Positioned(
   //                       top: 23.h,
   //                       right: 25.w,
   //                       child:Container(
   //                         decoration: BoxDecoration(
   //                             border: Border.all(
   //                                 color: Color(0xff0f0f0f)
   //                             ),
   //                             borderRadius: BorderRadius.circular(25)
   //                         ),
   //                         width: 102.w,
   //                         height: 39.h,
   //                         child: Center(child: Text('Earnings')),
   //                       )
   //                       ,),
   //                   ],
   //                 )
   //             ),
   //             Container(
   //               decoration: BoxDecoration(
   //                   border: Border(
   //                       bottom: BorderSide(width: 1,color: kGrey1)
   //                   )
   //               ),
   //               height: 97.h,
   //               width: MediaQuery.of(context).size.width,
   //               child: Stack(
   //                 children: [
   //                   Positioned(
   //                     child: const Text('TODAY\'S TRIPS'),
   //                     top: 21.h,
   //                     left: 25.w,),
   //                   Positioned(
   //                     top: 39.h,
   //                     left: 25.w,
   //                     child:Text('0',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
   //                     ,),
   //                   Positioned(
   //                     top: 23.h,
   //                     right: 25.w,
   //                     child:Container(
   //                       decoration: BoxDecoration(
   //                           border: Border.all(
   //                               color: Color(0xff0f0f0f)
   //                           ),
   //                           borderRadius: BorderRadius.circular(25)
   //                       ),
   //                       width: 102.w,
   //                       height: 39.h,
   //                       child: Center(child: Text('History')),
   //                     )
   //                     ,),
   //                 ],
   //               ),
   //             ),
   //             SizedBox(
   //               height: 100.h,
   //               width: MediaQuery.of(context).size.width,
   //               child: Stack(
   //                 children: [
   //                   Positioned(
   //                     child: const Text('AVERAGE RATING'),
   //                     top: 21.h,
   //                     left: 25.w,),
   //                   Positioned(
   //                     top: 39.h,
   //                     left: 25.w,
   //                     child:Text('0',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
   //                     ,),
   //                   Positioned(
   //                     top: 23.h,
   //                     right: 25.w,
   //                     child:Container(
   //                       decoration: BoxDecoration(
   //                           border: Border.all(
   //                               color: Color(0xff0f0f0f)
   //                           ),
   //                           borderRadius: BorderRadius.circular(25)
   //                       ),
   //                       width: 102.w,
   //                       height: 39.h,
   //                       child: Center(child: Text('Ratings')),
   //                     )
   //                     ,),
   //                 ],
   //               ),
   //             ),
   //
   //           ],),
   //       );
   //     });
   //   });
   //   hasBuiltBottomSheet = true;
   // }

    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 11.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    origin=Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: initialCameraPosition.target
    );
    double time = 0;
    double distance = 0;
    return Scaffold(
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
        top: 77.h,
        left: 25.w,
        child: backButton(context)),
        FutureBuilder(
        future: Geolocator.getCurrentPosition(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print('1,{$snapshot.data}');
          if(!snapshot.hasData){ return Positioned(
          bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight:Radius.circular(25),topLeft:Radius.circular(25))

                          ),
                          context: context,
                          builder: (context){
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: Column(
                                children: [
                                  StatefulBuilder(builder: (context, set2SheetState){
                                    Timer(Duration(seconds: 2),(){
                                      set2SheetState(() {
                                        is2Visible == false? is2Visible=true:is2Visible = false;
                                      });
                                    });
                                    return  SizedBox(
                                        height: 61.h,
                                        width: MediaQuery.of(context).size.width,
                                        child: isVisible == true?
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
                                            child: Center(child: Center(child:Text('LOOKING FOR RIDER...',style: TextStyle(fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.w500),),
                                            )))
                                    );
                                  }),
                                  Container(
                                      decoration: const BoxDecoration(
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
                                            child:Text('₦${balanceFormatter.format(earnings)}',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
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
                                              child: Center(child: Text('Earnings')),
                                            )
                                            ,),
                                        ],
                                      )
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
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
                                          child:Text('0',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
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
                                            child: Center(child: Text('History')),
                                          )
                                          ,),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 100.h,
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
                                          child:Text('0',style: TextStyle(fontSize: 25.sp,color: Color(0xff3ea57b)),)
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
                    },
                    child: Image.asset('lib/assets/images/handle.png',height: 35.h,width: 35.h,fit: BoxFit.contain,)),
                StatefulBuilder(
                    builder: (context, setSheetState){
                  Timer(Duration(seconds: 2),(){
                    setSheetState(() {
                      isVisible == false? isVisible=true:isVisible = false;
                    });
                  });
                  return  SizedBox(
                      height: 61.h,
                      width: MediaQuery.of(context).size.width,
                      child: isVisible == true?ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: kYellow),
                        onPressed: ()async{
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const CaptainHome()
                          ));
                        },
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('GO OFFLINE',style: TextStyle(fontSize: 15.sp,),),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ):Container(
                          color: kYellow,
                          height: 61.h,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: Center(child:Text('LOOKING FOR RIDER...',style: TextStyle(fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.w500),),
                          )))
                  );
                }),
              ],
            ),
          );}
          else{
           return RiderAvailable(position: snapshot.data,);
          }

        },

        )
      ],) ,);
  }
}

// Container(
// decoration: const BoxDecoration(
// color: kBlue,
// borderRadius: BorderRadius.only(topRight:Radius.circular(10),topLeft:Radius.circular(10))
// ),
// height: 341.h,
// width: MediaQuery.of(context).size.width,
// child: Stack(children: [
// Positioned(
// top: 36.h,
// left: 40.w,
// child: Container(
// width: 205.w,
// height: 61.h,
// child: Column(
// children: [
// Text('$time min . $distance km',style: TextStyle(fontSize: 30.sp,color: Colors.white),)
// ],
// ),
// ),)
// ],
// ),);