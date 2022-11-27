import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import '../../utilities/constants/textstyles.dart';
import '../../utilities/models/directions.dart';
import '../../utilities/widgets.dart';

class RideDestination extends StatefulWidget {
  RideDestination({Key? key, this.userLocation}) : super(key: key);
  String? userLocation;
  @override
  _RideDestinationState createState() => _RideDestinationState();
}

class _RideDestinationState extends State<RideDestination> {
  SharedPreferences? prefs;
  initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    endFocusNode.dispose();
    destFieldController.clear();
    endPosition = null;
  }
  bool bookForAnother = false;
  @override
  void initState() {
    originFieldController.text = widget.userLocation ?? 'Your location';
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
    initSharedPref();
    // TODO: implement initState
    super.initState();
    String apikey = apiKey;
    googlePlace = GooglePlace(apikey);
  }

  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions = [];
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

  DetailsResult? startPosition;
  DetailsResult? endPosition;
  late FocusNode startFocusNode;
  late FocusNode endFocusNode;
  Timer? debouce;
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).autofocus(endFocusNode);
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
          padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 15.h),
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Enter Destination',
                        style: kBoldBlack,
                      ),
                      SizedBox(
                        width: 46.w,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: Image.asset('lib/assets/menu.webp'),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 51.h,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 27.h),
                color: Color(0xffF4F4F9),
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        'lib/assets/images/originmarker.png',
                        height: 19.sp,
                        width: 19.sp,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 21.w, vertical: 16.h),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          if (debouce?.isActive ?? false) debouce!.cancel();
                          debouce = Timer(Duration(milliseconds: 100), () {
                            if (value.isNotEmpty) {
                              autoCompleteSearch(value);
                            } else {
                              setState(() {
                                predictions = [];
                                startPosition = null;
                              });
                            }
                          });
                        },
                        focusNode: startFocusNode,
                        controller: originFieldController,
                        decoration: InputDecoration(
                            suffixIcon: originFieldController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        predictions = [];
                                        originFieldController.clear();
                                        FocusScope.of(context).autofocus(startFocusNode);
                                        startPosition = null;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: kBlue,
                                    ))
                                : null,
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
                margin: EdgeInsets.only(top: 15.h),
                color: Color(0xffF4F4F9),
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        'lib/assets/images/dest_donut.png',
                        height: 19.sp,
                        width: 19.sp,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 21.w, vertical: 16.h),
                    ),
                    Expanded(
                      child: TextField(
                          focusNode: endFocusNode,
                          controller: destFieldController,
                          decoration: InputDecoration(
                              suffixIcon: destFieldController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          predictions = [];
                                          destFieldController.clear();
                                          FocusScope.of(context).autofocus(endFocusNode);
                                          endPosition = null;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: kBlue,
                                      ))
                                  : null,
                              hintText: 'Where to?',
                              border: InputBorder.none),
                          onChanged: (value) {
                            if (debouce?.isActive ?? false) debouce!.cancel();
                            debouce = Timer(Duration(milliseconds: 100), () {
                              if (value.isNotEmpty) {
                                autoCompleteSearch(value);
                              } else {
                                setState(() {
                                  predictions = [];
                                  endPosition = null;
                                });
                              }
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 181.h,
                  margin: EdgeInsets.only(top: 0.h),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.place_outlined),
                          title:
                              Text(predictions[index].description.toString()),
                          onTap: () async {
                            final placeId = predictions[index].placeId;
                            final details = await googlePlace.details.get(placeId!);
                            if (details != null &&
                                details.result != null &&
                                mounted) {
                              if (startFocusNode.hasFocus) {
                                setState(() {
                                  startPosition = details.result;
                                  originFieldController.text =
                                      details.result!.name!;
                                  predictions = [];
                                  FocusScope.of(context).nextFocus();
                                });
                                bookForAnother = true;
                              } else {
                                setState(() {
                                  endPosition = details.result;
                                  destFieldController.text =
                                      details.result!.name!;
                                  predictions = [];
                                });
                              }
                              if (bookForAnother == false &&
                                  endPosition != null &&
                                  originFieldController.text != '') {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context, builder: (context){
                                  return Container(child:
                                  SpinKitCircle(
                                    color: kYellow,
                                  ),);
                                });
                                predictions = [];
                                Future.delayed(Duration(seconds: 5));
                                Position position =
                                    await determinePosition(context);
                                LatLng userCoord = LatLng(
                                    position.latitude, position.longitude);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                saveUserLocation(
                                    wynkId: prefs.getString('Origwynkid')!,
                                    userCoordinates: userCoord);
                                context.read<FirstData>().savePCLocat(userCoord);
                                context.read<FirstData>().saveEndPos(endPosition!);
                                Navigator.pop(context);
                                navScreenController.text = destFieldController.text;
                                Navigator.pushNamed(context, '/NavScreen');
                              } else if (bookForAnother == true &&
                                  endPosition != null &&
                                  startPosition != null) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context, builder: (context){
                                  return Container(child:
                                  SpinKitCircle(
                                    color: kYellow,
                                  ),);
                                });
                                predictions = [];
                                Future.delayed(Duration(seconds: 5));
                                // Position position =
                                //     await determinePosition(context);
                                // LatLng userCoord = LatLng(
                                //     position.latitude, position.longitude);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                context.read<FirstData>().saveStartPos(startPosition!);
                                context.read<FirstData>().saveEndPos(endPosition!);
                                saveUserLocation(
                                    wynkId: prefs.getString('Origwynkid')!,
                                    userCoordinates: LatLng(context.read<FirstData>().startPos!.geometry!.location!.lat!,
                                        context.read<FirstData>().startPos!.geometry!.location!.lng!));
                                context.read<FirstData>().savePCLocat(null);
                                //context.read<FirstData>().savePCLocat(userCoord);

                                Navigator.pop(context);
                                navScreenController.text = destFieldController.text;
                                Navigator.pushNamed(context, '/NavScreen');
                              }
                            }
                          },
                        );
                      }),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/RideSchedulePickup');
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
                              borderRadius: BorderRadius.circular(25.h)),
                          child: Row(
                            children: [
                              Icon(Icons.history),
                              Text(
                                'Schedule Ride',
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                        Positioned(
                          left: 124.w,
                          bottom: 39.h,
                          child: Image.asset(
                            'lib/assets/images/rideSchedule.png',
                            width: 22.w,
                            height: 22.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
