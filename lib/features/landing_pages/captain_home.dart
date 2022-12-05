
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/features/landing_pages/captain_online.dart';
import 'package:wynk/features/registration_feature/captain_f_registration.dart';
import 'package:wynk/features/ride/ride_destination.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/models/directions.dart';
import 'package:wynk/utilities/models/directions_model.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
import 'package:location/location.dart';

import '../wynk-pass/wynk_pass_confirmation.dart';
import 'home_main14.dart';
class CaptainHome extends StatefulWidget {
  const CaptainHome({Key? key}) : super(key: key);

  @override
  State<CaptainHome> createState() => _CaptainHomeState();
}

class _CaptainHomeState extends State<CaptainHome> with SingleTickerProviderStateMixin {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  num vaultBalance=0;
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController?.dispose();
    locationSubscription?.cancel();
  }
  Position? pos;
  BitmapDescriptor? currentLocatBitmap;
  void genIconBitMap()async{
    currentLocatBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/rides/car2.png",
    );

    setState(() {
    });
  }
  LatLng? userCurLocat;
  double? rotation;
  StreamSubscription<LocationData>? locationSubscription;
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    accountBalCont.text =  '₦${context.read<FirstData>().vaultB}';
    context.read<FirstData>().saveUserType('2');
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  GoogleMapController? _googleMapController;
  Marker? origin;
  Location location = Location();
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

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool showBalance = true;
  Icon icon = Icon(CupertinoIcons.eye_slash_fill);
  List<Marker> markers = [];


  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition=CameraPosition(
        zoom: 11.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    origin=Marker(
        anchor: Offset(0.5,0.5),
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'You are here'),
        icon: BitmapDescriptor.fromBytes(context.read<FirstData>().curMarker2!),
        position: userCurLocat??initialCameraPosition.target,
        rotation: rotation??0,
        zIndex: 30
    );
    markers.add(origin!);
    return WillPopScope(
      onWillPop: ()async{
        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
            HomeMain14()));
        return false;
      },
      child: Scaffold(
        key: _key,
        drawer: Drawer(
          width: 250.w,
          child: DrawerWidget(),
        ),
        body: Stack(children: [
          GoogleMap(
            markers: markers.map((e) => e).toSet(),
            onMapCreated: GMapCont,
            myLocationEnabled: false,
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
                        backgroundColor: kBlue),
                    onPressed: ()async{

                      showDialog(context: context, builder: (context){
                        return Container(child:
                        SpinKitCubeGrid(
                          color: kYellow,
                        ),);
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? wynkid = prefs.getString('Origwynkid');
                      context.read<FirstData>().saveUniqueId(wynkid);
                       final passStatus = await getCurrentPass();

                     if(passStatus['statusCode'] == 200){
                       Navigator.pop(context);
                       context.read<FirstData>().saveCapOnlineStat(true);
                       Navigator.pushReplacementNamed(context,'/CaptainOnline');}
                     else{
                       showToast(passStatus['errorMessage']);
                       final passNum = await passDetail();
                       context.read<PassSubDetails>().prepaidPasses.clear();
                       context.read<PassSubDetails>().postpaidPasses.clear();
                       final passes = passNum['message'] as List;
                       for(Map<String, dynamic> pass in passes){
                        WhiteWynkPass passModel = WhiteWynkPass(
                           subType: 'post-paid',
                           amount: pass['amount'],
                           passName: pass['pass_name'],
                           passId: pass['pass_id'],
                           duration: pass['duration'],
                        );
                        if(pass['pass_type'] == '1'){context.read<PassSubDetails>().savePrepaidPass(passModel);}
                        if(pass['pass_type'] == '2'){context.read<PassSubDetails>().savePostpaidPass(passModel);}
                       }
                       Navigator.pop(context);
                       Navigator.pushNamed(context, '/PassHome');
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
        ],) ,),
    );
  }
}

