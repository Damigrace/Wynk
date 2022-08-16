
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';

import '../../main.dart';
class RideHome extends StatefulWidget {
  const RideHome({Key? key}) : super(key: key);

  @override
  State<RideHome> createState() => _RideHomeState();
}

class _RideHomeState extends State<RideHome> {
  Position? pos;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  static const _initialCameraPosition=CameraPosition(
      zoom: 11.5,
      target: LatLng(7.091355, 5.148420));
  GoogleMapController? _googleMapController;
  void GMapCont(GoogleMapController controller){
    _googleMapController=controller;
  }
  Widget modalBsheet(BuildContext context){return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
    ),
    padding: EdgeInsets.only(left: 25.w,right: 26.w,top: 42.h),
    child: Column(children: [
      Image.asset('lib/assets/images/handle.png'),
    SizedBox(height: 17.h,),
    Container(
      color: Color(0xffF4F4F9),
      child: TextField(
        onSubmitted: (v)=>print(v),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
            hintText: 'Where To?',
            contentPadding: EdgeInsets.all(15),
            border: InputBorder.none),
        onChanged: (value) {
          // do something
        },
      ),
    ),
      SizedBox(height: 17.h,),
      Padding(padding: MediaQuery.of(context).viewInsets)
    ],),);}
  @override
  Widget build(BuildContext context) {
   CameraPosition initialCameraPosition=CameraPosition(
        zoom: 11.5,
        target: LatLng(context.read<FirstData>().lat!,context.read<FirstData>().long!));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
      GoogleMap(
        onMapCreated: GMapCont,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition : _initialCameraPosition,
      ),
      Positioned(
        bottom: 1,
        child: SizedBox(
          height: 61.h,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kBlue
            ),
            onPressed: (){
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                  context: context, builder:(context)=> Wrap(children: [
                    modalBsheet(context)
              ],));
            },
            child: Text('Take a ride',style: TextStyle(fontSize: 20.sp),),
          ),
        ),
      )
    ],) ,);
  }
}