import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/models/directions.dart';
import '../../utilities/models/directions_model.dart';
import '../../utilities/models/pdf.dart';
import '../../utilities/widgets.dart';
import '../landing_pages/home_main14.dart';

class PatronInvoice extends StatefulWidget {

  @override
  _PatronInvoiceState createState() => _PatronInvoiceState();
}

class _PatronInvoiceState extends State<PatronInvoice> {
  late CameraPosition startPos;
  late CameraPosition endPos;
  mapLocations()async{
    final direct=await DirectionsRepo().getDirections(origin: startPos.target, destination: endPos.target);
    setState(() {
      _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,30.w));
      info=direct;
    });
  }
  @override
  void dispose(){

    _googleMapController?.dispose();
    super.dispose();


  }
  @override
  void initState() {

    startPos=CameraPosition(target: context.read<FirstData>().patronCurentLocation??
        LatLng(context.read<FirstData>().startPos!.geometry!.location!.lat!,
            context.read<FirstData>().startPos!.geometry!.location!.lng!));
    endPos=CameraPosition(target: LatLng(
        context.read<FirstData>().endPos!.geometry!.location!.lat!,
        context.read<FirstData>().endPos!.geometry!.location!.lng!));
    // TODO: implement initState
    super.initState();

  }

  GoogleMapController? _googleMapController;
  Marker? origin;

  Marker? destination;
  Directions? info;

  void GMapCont(GoogleMapController controller){
    context.read<FirstData>().backButton(false);
    _googleMapController=controller;
    context.read<CaptainDetails>().savePatronLocation(startPos.target);
    mapLocations();
  }
  double? devWidth;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  ScreenshotController avatarController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    print('building patron invoice');
    endPos=CameraPosition(target: LatLng(
        context.read<FirstData>().endPos!.geometry!.location!.lat!,
        context.read<FirstData>().endPos!.geometry!.location!.lng!));
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
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _key,
      drawer: Drawer(
        width: 250.w,
        child: DrawerWidget(),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only( top: 15.h),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: Image.asset('lib/assets/menu.webp'),
                        ),
                      ),
                    ),
                    SizedBox(height: 52.h,),
                    Text('Ride History',style: TextStyle(fontSize: 26.sp),),
                    SizedBox(height: 21.h,),
                    Screenshot(
                      controller: screenshotController,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: Image.asset('lib/assets/images/greenmarker.png')),
                                SizedBox(width: 21.w,),
                                Expanded(
                                  child: Text( context.read<FirstData>().patronPickupPlace!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18.sp),),)
                              ],
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                SizedBox(height: 38.h,width: 9.w,),
                                VerticalDivider(width: 3,color: Colors.black,),
                                SizedBox(height: 38.h,)
                              ],),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: Image.asset('lib/assets/images/redmarker.png')),
                                SizedBox(width: 21.w,),
                                Expanded(
                                  child: Text( context.read<FirstData>().patronDestPlace!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18.sp),),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 28.h,),
                  ],
                ),
              ),

              Container(
                width: 390.w,
                height: 175.h,
                child: GoogleMap(
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
                  initialCameraPosition : startPos,
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 29.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your ride with ${context.read<CaptainDetails>().capName}',style: TextStyle(fontSize: 18.sp),),
                            SizedBox(height: 10.h,),
                            Text(context.read<CaptainDetails>().capPlate!,style: TextStyle(fontSize: 18.sp)),
                            SizedBox(height: 22.h,),
                            Text('${DateFormat.MMMMEEEEd().format(DateTime.now())}',style: TextStyle(fontSize: 18.sp),)
                          ],),
                        Screenshot(
                          controller: avatarController,
                          child: SizedBox(
                            width: 80.w,
                            height: 80.h,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<CaptainDetails>().capId}.png'),),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 29.h),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Fare',style: TextStyle(fontSize: 22..sp,fontWeight: FontWeight.w600),),
                          Text('Amount',style: TextStyle(fontSize: 22..sp,fontWeight: FontWeight.w600))
                        ]),
                    SizedBox(height: 20.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Base Fare',style: TextStyle(fontSize: 18.sp),),
                          Text('₦ ${context.read<CaptainDetails>().baseFair}',style: TextStyle(fontSize: 18.sp),),
                        ]),
                    SizedBox(height: 10.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Time',style: TextStyle(fontSize: 18.sp),),
                          Text('₦ ${context.read<CaptainDetails>().time}',style: TextStyle(fontSize: 18.sp),),
                        ]),
                    SizedBox(height: 10.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Distance',style: TextStyle(fontSize: 18.sp),),
                          Text('₦ ${context.read<CaptainDetails>().distance}',style: TextStyle(fontSize: 18.sp),),
                        ]),
                    SizedBox(height: 10.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Convenience Fee',style: TextStyle(fontSize: 18.sp),),
                          Text('₦ ${context.read<CaptainDetails>().convFee}',style: TextStyle(fontSize: 18.sp),),
                        ]),
                    SizedBox(height: 10.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Road Maintenance',style: TextStyle(fontSize: 18.sp),),
                          Text('₦ ${context.read<CaptainDetails>().roadMaint}',style: TextStyle(fontSize: 18.sp),),
                        ]),
                    SizedBox(height: 10.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Total',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600),),
                          Text('₦ ${context.read<CaptainDetails>().total}',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600),),
                        ]),
                    SizedBox(height: 20.h,),
                  ],
                ),
              ),
              Container(
                width: 393.w,
                height: 61.h,
                padding: EdgeInsets.only(left: 36.w, right: 36.w),
                decoration: BoxDecoration(
                    border: Border.all(color: kGrey1)
                ),
                child: Center(child: Row(children: [
                  Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                  SizedBox(width: 18.w,),
                  Flexible(child: SizedBox(width:260.w,child: Text('My Vault',style: TextStyle(fontSize: 18.sp),))),
                  Text('₦ ${context.read<FirstData>().vaultB}',style: TextStyle(fontSize: 18.sp))
                ],) ,),
              ),
              GestureDetector(
                onTap:(){
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                  //     HomeMain14()));
                } ,
                child: Container(
                  width: 318.h,
                  margin: EdgeInsets.only(left: 36.w, right: 36.w, top: 42.h),
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Text('Get help with ride',
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500)),
                  ),
                ),),
              GestureDetector(
                onTap:(){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                      HomeMain14()));
                } ,
                child: Container(
                  width: 318.h,
                  margin: EdgeInsets.only(left: 36.w, right: 36.w, top: 15.h),
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text('Return to Home',
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: kWhite)),
                  ),
                ),),
              SizedBox(height: 15.h,),
              GestureDetector(
                onTap:()async{


                    final ByteData bytes = await rootBundle.load('lib/assets/images/rides/wynkvaultwallet.png');
                    final Uint8List list = bytes.buffer.asUint8List();
                    Uint8List? green;
                    Uint8List? red;
                    final ByteData bytes0 = await rootBundle.load('lib/assets/images/greenmarker.png');
                    green = bytes0.buffer.asUint8List();
                    final ByteData bytes1 = await rootBundle.load('lib/assets/images/dest_donut.png');
                    red = bytes1.buffer.asUint8List();
                    Uint8List? mapByte =await _googleMapController?.takeSnapshot();
                    Uint8List? userAvat = await avatarController.capture(delay: const Duration(milliseconds: 10),pixelRatio: MediaQuery.of(context).devicePixelRatio).then((value) {return value;});
                    final PDF = await pdf(green,red, mapByte!,context.read<CaptainDetails>().capName!,
                        DateFormat.MMMMEEEEd().format(DateTime.now()),
                        list,context.read<CaptainDetails>().capPlate!,userAvat!,
                        context.read<CaptainDetails>().baseFair!,context.read<CaptainDetails>().time!,
                        context.read<CaptainDetails>().distance!,context.read<CaptainDetails>().convFee!,
                        context.read<CaptainDetails>().roadMaint!,context.read<CaptainDetails>().total!,
                        context.read<FirstData>().patronPickupPlace!,
                        context.read<FirstData>().patronDestPlace!
                    );

                    await DocumentFileSavePlus.saveFile(PDF, "invoice${DateTime.now().toString()}.pdf", "appliation/pdf");
                    showSnackBar(context,'Invoice downloaded successfully');
                } ,
                child: Container(
                  width: 318.h,
                  margin: EdgeInsets.only(left: 36.w, right: 36.w, top: 15.h),
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: kBlue)
                  ),
                  child: Center(
                    child: Text('Download invoice',
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: kBlue)),
                  ),
                ),),
              SizedBox(height: 15.h,)
            ],
          ),
        ),
      ),
    );
  }
}