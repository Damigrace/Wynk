
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
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
class RideCommence extends StatefulWidget {

  RideCommence({Key? key,}) : super(key: key);

  @override
  State<RideCommence> createState() => _RideCommenceState();
}

class _RideCommenceState extends State<RideCommence> {
  Timer? timer;
  late CameraPosition startPos;
  late CameraPosition endPos;
  bool notified1 = false;
  bool notified2 = false;
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
              timer?.cancel();
              notified1 = true;
                Navigator.pushReplacementNamed(context,'/RidePaymentGateway');
            }
          }

          break;
        case '1':
          {
            if(notified2 == false){
              timer?.cancel();
              notified2= true;
              Navigator.pushReplacementNamed(context,'/TripEnded');
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
    locationSubscription?.cancel();
  }
  late GooglePlace googlePlace;
  String? totalDuration;

  @override
  void initState() {
    context.read<FirstData>().saveActiveRide(true);
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
        return await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
            HomeMain14()));
      },

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
            markers: markers.map((e) => e).toSet(),
            circles: {
              circle!,
            },
            onMapCreated: GMapCont,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition : startPos,
          ),
          Visibility(
              visible:context.watch<FirstData>().showBackbutton!,
              child:
              Container(
                margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 69.h),
                child:backButton(context) ,)
          ),
          DraggableScrollableSheet(
              controller: rideCommenceCont,
              maxChildSize: 0.5,
              initialChildSize: 0.47,
              minChildSize: 0.47,
              builder: (context, scrollController1) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(right: 39.w),
                      child: SizedBox(
                        height: 51.h,
                        width: 51.w,
                        child: Image.asset('lib/assets/images/sos.png'),
                      ),
                    ),
                    Container(
                      width: 390.w,
                     // height: 322.h,
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
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
                          SizedBox(height: 6.h,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:  CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 15.h,),
                              Text("You'll arrive in ${context.read<FirstData>().totalDuration}",style: TextStyle(fontSize: 18.sp),),
                              Flexible(child: SizedBox(height: 48.h,)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${context.read<CaptainDetails>().carColor} ${context.read<CaptainDetails>().carBrand} ${context.read<CaptainDetails>().carModel}',style: TextStyle(fontSize: 10.sp),),
                                      SizedBox(height: 9.h,),
                                      Text(context.read<CaptainDetails>().capPlate!,style: TextStyle(fontSize: 18.sp),),
                                      SizedBox(height: 22.h,),
                                      Text('Your Captain is ${context.read<CaptainDetails>().capName}',style: TextStyle(fontSize: 18.sp),),
                                    ],),
                                  Container(
                                    width: 71.w,height: 81.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(child: SizedBox(
                                          width: 70.w,
                                          height: 70.h,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<CaptainDetails>().capId}.png'),
                                          ),
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
                                                  direction: Axis.horizontal,
                                                  itemBuilder: (context, index) => Icon(Icons.star,color: kYellow,),
                                                  rating:double.parse(context.read<CaptainDetails>().capRating!,
                                                ),
                                              ),
                                            ))
                                        )],
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
                                    showModalBottomSheet(
                                        barrierColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                                        context: context,builder: (context){return DraggableScrollableSheet(
                                        controller: shareTripCont,
                                        maxChildSize: 0.4,
                                        initialChildSize: 0.4,
                                        minChildSize: 0.2,
                                        builder: (context, scrollController1) {
                                          return Container(
                                            width: 390.w,
                                            height: 253.h,
                                            padding: EdgeInsets.symmetric(horizontal: 17.w),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                            ),
                                            child: ListView(
                                              controller: scrollController1,
                                              shrinkWrap:  true,
                                              children: [
                                                SizedBox(height: 10.h,),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Image.asset('lib/assets/images/rides/handledown.png',width: 56.w,height: 11.h,)
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Share trip details',style: TextStyle(fontSize:18.sp ),),
                                                    SizedBox(
                                                        width: 42.w,
                                                        height: 42.h,
                                                        child: Image.asset('lib/assets/images/rides/cancel1.png'))
                                                  ],
                                                ),
                                                Text('Send your live location to your family and\nfriends so they know where you are.',
                                                    style: TextStyle(fontSize:12.5.sp ,color: Colors.black26)),
                                                SizedBox(height: 28.h,),
                                                Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: GestureDetector(
                                                        onTap: (){
                                                          print('ghi');
                                                          Clipboard.setData(ClipboardData(text: context.read<FirstData>().endPos?.name)).
                                                          then((value) => showToast('Destination copied'));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.copy),
                                                            SizedBox(width: 16.w,),
                                                            Text('Copy to Clipboard',style: TextStyle(fontSize: 18.sp),)
                                                          ],
                                                        ))),
                                                SizedBox(height: 32.h,),
                                                Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: GestureDetector(
                                                        onTap: (){
                                                          print('ghi');
                                                          sendWhatsappMessage(num: '+2348145568887', text: 'Message');
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.people_alt_outlined),
                                                            SizedBox(width: 16.w,),
                                                            Text('Send to Emergency Contact',style: TextStyle(fontSize: 18.sp),)
                                                          ],
                                                        ))),
                                              ],
                                            ),
                                          );
                                        }) ;});

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
                    ),
                  ],
                );
              })
        ],) ,),
    );
  }
}



