import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/landing_pages/captain_online.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
import '../../services.dart';
class NoPassStatus extends StatefulWidget {
  NoPassStatus({Key? key}) : super(key: key);
  @override
  _NoPassStatusState createState() => _NoPassStatusState();
}

class _NoPassStatusState extends State<NoPassStatus> {
  String? inputPin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 15.w,top: 20.h,right: 7.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: backButton(context),
                ),
                SizedBox(height: 25.h,),
                Center(child:
                Column(
                  mainAxisSize:  MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/images/rides/nothingtodisp.png'),
                    SizedBox(height: 23.h,),
                    Text('You do not have an active pass',style: TextStyle(fontSize: 18.sp),),
                    SizedBox(height: 8.h,),
                  ],
                ),),
                SizedBox(height: 100.h,),
                Text('Select a Plan to purchase or renew',style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w500),),
                Container(
                  padding:  EdgeInsets.only(left: 30.w,top: 15.h,right: 7.w),
                  alignment: Alignment.bottomLeft,
                  child: Text('Pre-paid Plans',style: TextStyle(color: Colors.black,
                      fontSize: 22.sp, fontWeight: FontWeight.w500),),),
                SizedBox(height: 10.h,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: context.read<PassSubDetails>().prepaidPasses)
                  ,),
                Container(
                  padding:  EdgeInsets.only(left: 30.w,top: 15.h,right: 7.w,bottom: 10),
                  alignment: Alignment.bottomLeft,
                  child: Text('Post-paid Plans',style: TextStyle(color: Colors.black,
                      fontSize: 22.sp, fontWeight: FontWeight.w500),),),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: context.read<PassSubDetails>().postpaidPasses)
                  ,),
                SizedBox(height: 10.h,),
              ],),
          ),
        ),
      ),
    );
  }


}