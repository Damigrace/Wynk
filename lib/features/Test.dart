import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


import '../services.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/textstyles.dart';
import 'landing_pages/home_main14.dart';
class Test1 extends StatefulWidget {
   Test1({Key? key}) : super(key: key);

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  Timer? timing;
  LatLng? capCurrLocat;

  @override
  void initState() {
    // TODO: implement initState

  }
  @override
  void dispose() {
    // TODO: implement dispose
   timing?.cancel();
   print('disposing');
    super.dispose();
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    print('deactivating');
    timing?.cancel();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 30.w),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(children: [
                  Container(
                    width: 177.w,
                    height: 177.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(9)
                    ),
                    width: 150.w,
                    height: 150.w,
                    child: Image.asset('lib/assets/images/rides/wynkvaultwallet.png'),
                  ),

                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                          width: 57.w,
                          height: 57.w,
                          child: Image.asset('lib/assets/images/airtime_logo/payment_success.png'))),
                ],),
                SizedBox(height: 27.h,),
                Text('Success',
                  style: TextStyle(fontSize: 26.sp,color: Colors.green),
                  textAlign: TextAlign.center,),
                SizedBox(height: 10.h,),
                Text.rich(

                  TextSpan(

                      style: TextStyle(fontSize: 14.sp,height: 1.3.h),
                      text: 'You have successfully paid a sum of ',
                      children: [
                        WidgetSpan(child:
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('amount', style: TextStyle(fontSize: 14.sp),),
                            Text('to Wynk for airtime purchase'
                                '', style: TextStyle(fontSize: 14.sp),),
                          ],
                        )
                        )
                      ]
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 54.h,),
                GestureDetector(
                  onTap: (){{

                  };},
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text('Make another payment',
                        style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                    ),
                  ),),
                GestureDetector(
                  onTap:(){
                    timing?.cancel();
                    //Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                        HomeMain14()));
                  } ,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    margin: EdgeInsets.only(top:15.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Text('Go Home',
                          style: TextStyle(fontSize: 15.sp)),
                    ),
                  ),),
              ],),
          ),
        ),
      ),
    );
  }
}
