
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/controllers.dart';
import 'package:wynk/features/ride/ride_destination.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/constants/textstyles.dart';
import 'package:wynk/utilities/models/directions.dart';
import 'package:wynk/utilities/models/directions_model.dart';
import 'package:wynk/utilities/widgets.dart';

import '../../main.dart';
import '../../utilities/constants/env.dart';
import '../modal_bottom_sheets/driver -search_mbs.dart';
class NavScreen extends StatefulWidget {
  NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {

  late CameraPosition startPos;
  late CameraPosition endPos;
  mapLocations()async{
      final direct=await DirectionsRepo().getDirections(origin: startPos.target, destination: endPos.target);
      setState(() {
        _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
        info=direct;
        totalDuration = info?.totalDuration;
        context.read<FirstData>().saveTotalDuration(totalDuration!);
      });

  }
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  var userPImage;
  double minChildSize = 0.1;
  double minChildSize1 = 0.2;
  endProcesses(){
    _googleMapController?.dispose();
    //originFieldController.clear();
    locationSubscription1?.cancel();
  }
  @override
  void dispose(){
  endProcesses();
  print(' disposed  ahaahhahhahhhahhahahahahahahahhahahahahhaha' );
    super.dispose();
  }

  @override
  void deactivate() {
    endProcesses();
    // TODO: implement deactivate
    print(' deactive  ahaahhahhahhhahhahahahahahahahhahahahahhaha' );
    super.deactivate();
  }
  late GooglePlace googlePlace;
   String? totalDuration;
   updatePolyline()async{
     final direct=await DirectionsRepo().getDirections(origin: startPos.target, destination: endPos.target);
       _googleMapController?.moveCamera(CameraUpdate.newLatLngBounds(Directions.bbounds,50.w));
       info=direct;
       totalDuration = info?.totalDuration;
       setState(() {

       });
   }
  @override
  void initState() {

    startPos=CameraPosition(target: context.read<FirstData>().patronCurentLocation??
        LatLng(context.read<FirstData>().startPos!.geometry!.location!.lat!,
            context.read<FirstData>().startPos!.geometry!.location!.lng!));
    endPos=CameraPosition(target: LatLng(
        context.read<FirstData>().endPos!.geometry!.location!.lat!,
        context.read<FirstData>().endPos!.geometry!.location!.lng!));
    String apikey=apiKey;
    googlePlace=GooglePlace(apikey);
    initSharedPref();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    // TODO: implement initState
    super.initState();

    userPImage =base64Decode(profileImg);
  }
  StreamSubscription? locationSubscription1;
  bool showTopNav = true;
  bool showBackButton = false;
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? curLocat;
  Marker? destination;
  Directions? info;
  Directions? newInfo;
  Location location = Location();
  void GMapCont(GoogleMapController controller){
    context.read<FirstData>().backButton(false);
    _googleMapController=controller;
    context.read<CaptainDetails>().savePatronLocation(startPos.target);
     mapLocations();
    // if(mounted ){
    //   locationSubscription1 = location.onLocationChanged.listen((event) {
    //     context.read<FirstData>().updateLocat(LatLng(event.latitude!, event.longitude!));
    //     context.read<FirstData>().updateRotat(event.heading!);
    //     // setState(() {
    //     //   userCurLocat = LatLng(event.latitude!, event.longitude!);
    //     //   rotation = event.heading;
    //     // });
    //     _googleMapController?.moveCamera(
    //         CameraUpdate.newCameraPosition(CameraPosition(
    //             target: LatLng(event.latitude!,event.longitude!),
    //             zoom: 16))
    //     );
    //   });
    // }
  }
  double? devWidth;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  BitmapDescriptor? originBitmap;
  BitmapDescriptor? destBitmap;
  BitmapDescriptor? currentLocatBitmap;

  void radioOnChanged( String? image, String? paymentMeans){
    context.read<FirstData>().saveRideImage(image!);
    setState(() {
      if(groupValue==0){
        context.read<FirstData>().savePaymentMeans(paymentMeans);
        groupValue=1;
        Navigator.pop(context);
        showModalBottomSheet(
          enableDrag: false,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.transparent,
            isDismissible: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            context: context, builder: (context){
          return DriverSearch(
            totalDuration: totalDuration,
            carImage: image,
            wynkid:  prefs?.getString('Origwynkid',),
            endPosition: endPos.target,
            startPosition: startPos.target,);
        });
        groupValue = 0;
      }
      else{groupValue=0;}
    });
  }
  double minEx = 0.1;
  int groupValue=0;
  LatLng? userCurLocat;
  double? rotation;
  List<ChatTile> messages = [];
  Icon icon = Icon(Icons.keyboard_arrow_down);
  List<AutocompletePrediction> predictions = [];
  DetailsResult? endPosition;
  Timer? debouce;
  void autoCompleteSearch(String value) async {
    String? locale =await getActualLocale();
    var result = await googlePlace.autocomplete
        .get(value, components: [Component('country', locale )]);
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
  bool searchView = false;
  Circle? circle;
  @override
  Widget build(BuildContext context) {
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
            ),
          },
          markers: markers.map((e) => e).toSet(),
          onMapCreated: GMapCont,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition : startPos,
        ),
        Visibility(
          visible: context.watch<FirstData>().showTopbar!,
          child: Column(
            children: [
              Container(
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
                      style: kBoldBlack,
                     // textAlignVertical: TextAlignVertical.top,
                      cursorColor: kBlue,
                      autofocus: false,
                      controller: navScreenController,
                        decoration: InputDecoration(
                          prefix: SizedBox(width: 10.w,),
                            suffixIcon: destFieldController.text.isNotEmpty
                                ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    predictions = [];
                                    navScreenController.clear();
                                    endPosition = null;
                                  });
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: kBlue,
                                ))
                                : null,
                            hintText: navScreenController.text,
                          //  contentPadding: EdgeInsets.symmetric(horizontal: 13.w),
                            border: InputBorder.none),
                      onChanged: (value){if (debouce?.isActive ?? false) debouce!.cancel();
                        debouce = Timer(Duration(milliseconds: 100), () {
                          searchView = true;
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {
                            setState(() {
                              predictions = [];
                              endPosition = null;
                            });
                          }
                        });},
                    ),
                  ),
                  Icon(Icons.add)
                ],),
              ),
              Visibility(
                visible: searchView,
                child: Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),

                    width: MediaQuery.of(context).size.width,
                    height: 200.h,
                    margin: EdgeInsets.only(top: 10.h,left: 12.w,right: 16.w,),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.place_outlined),
                            title:
                            Text(predictions[index].description.toString()),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final placeId = predictions[index].placeId;
                              final details =
                              await googlePlace.details.get(placeId!);
                              if (details != null &&
                                  details.result != null &&
                                  mounted) {
                                  endPosition = details.result;
                                  navScreenController.text = details.result!.name!;
                                  predictions = [];
                                showDialog(
                                    barrierDismissible: false,
                                    context: context, builder: (context){
                                  return Container(child:
                                  SpinKitCircle(
                                    color: kYellow,
                                  ),);
                                });
                                Position position = await determinePosition(context);
                                LatLng userCoord = LatLng(position.latitude, position.longitude);
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                saveUserLocation(
                                    wynkId: prefs.getString('Origwynkid')!,
                                    userCoordinates: startPos.target);
                                context.read<FirstData>().savePCLocat(userCoord);
                                context.read<FirstData>().saveEndPos(endPosition!);
                                await updatePolyline();
                                updatePolyline();
                                searchView = false;
                                Navigator.pop(context);
                                  FocusScope.of(context).unfocus();
                              }
                            },
                          );
                        }),
                  ),
                ),
              ),
            ],
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
         controller: firstNavCont,
         maxChildSize: 0.8,
           initialChildSize: 0.3,
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
                       onTap: (){
                       },
                       child: CircleAvatar(radius: 12.r,child: icon,backgroundColor: Color(0xffF3F3F3),))
                 ],),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   firstNavCont.jumpTo(minChildSize);
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
                           maxChildSize: 0.42,
                           initialChildSize: 0.42,
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
                                   padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w,),
                                   child: ListView(
                                     shrinkWrap: true,
                                     children: [
                                       Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                                       SizedBox(height: 22.h,),
                                       Rides(
                                         image: 'lib/assets/images/rides/economy.png',
                                         title: 'Economy',
                                         time: '10:20 Dropoff',
                                         price: '₦ 700 - ₦ 1,100', color: Color(0xffF7F7F7),),
                                       SizedBox(height: 21.h,),
                                       Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                       SizedBox(
                                         child: Container(
                                           padding: EdgeInsets.only(top: 17.h),
                                           width: double.infinity,
                                           child: Row(children: [
                                             Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                             SizedBox(width: 18.w,),
                                             Flexible(child: SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),))),
                                             Radio<int>(
                                                 toggleable: true,
                                                 activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){
                                                   radioOnChanged('lib/assets/images/rides/economy.png', 'wallet');
                                                 }
                                             )
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
                                           Flexible(child: SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(
                                               toggleable: true,
                                               activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/economy.png', 'cash');

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
                   time: '$totalDuration Dropoff',
                   price: '₦ 700 - ₦ 1,100', color: Color(0xffF7F7F7),),
               ),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   firstNavCont.jumpTo(minChildSize);
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
                                       time: '$totalDuration Dropoff',
                                       price: '₦ 900 - ₦ 1,500', color: Color(0xffF7F7F7),),
                                     SizedBox(height: 21.h,),
                                     Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                     SizedBox(
                                       child: Container(
                                         padding: EdgeInsets.only(top: 17.h),
                                         width: double.infinity,
                                         child: Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           Flexible(child: SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(toggleable: true,activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/sedan.png', 'wallet');
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
                                           Flexible(child: SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(toggleable: true,activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/sedan.png', 'cash');
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
                   price: '₦ 900 - ₦ 1,500', color: Color(0xffF7F7F7),),
               ),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   firstNavCont.jumpTo(minChildSize);
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
                                       price: '₦ 700 - ₦ 1,100', color: Colors.white,),
                                     SizedBox(height: 21.h,),
                                     Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                     SizedBox(
                                       child: Container(
                                         padding: EdgeInsets.only(top: 17.h),
                                         width: double.infinity,
                                         child: Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           Flexible(child: SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(toggleable: true,activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/taxi.png', 'wallet');
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
                                           Flexible(child: SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(toggleable: true,activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/taxi.png', 'cash');
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
                   price: '₦ 700 - ₦ 1,100', color: Colors.white,),
               ),
               SizedBox(height: 22.h,),
               GestureDetector(
                 onTap: (){
                   firstNavCont.jumpTo(minChildSize);
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
                                       price: '₦ 500 - ₦ 700', color: Colors.white,),
                                     SizedBox(height: 21.h,),
                                     Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                                     SizedBox(
                                       child: Container(
                                         padding: EdgeInsets.only(top: 17.h),
                                         width: double.infinity,
                                         child: Row(children: [
                                           Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                                           SizedBox(width: 18.w,),
                                           Flexible(child: SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(toggleable: true,activeColor:kYellow,value: 1, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/moto.png', 'wallet');
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
                                           Flexible(child: SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),))),
                                           Radio<int>(toggleable: true,activeColor:kYellow,value: 2, groupValue: groupValue, onChanged: (value){
                                             radioOnChanged('lib/assets/images/rides/moto.png', 'cash');
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
                   price: '₦ 500 - ₦ 700', color: Colors.white,),
               ),
             ],
           )
             ,),
          );
       })
      ],) ,);
  }
}
