import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/features/landing_pages/captain_online.dart';
import 'package:wynk/main.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/widgets.dart';

import '../../controllers.dart';
import '../../services.dart';
class PassStatus extends StatefulWidget {
  PassStatus({Key? key}) : super(key: key);
  @override
  _PassStatusState createState() => _PassStatusState();
}

class _PassStatusState extends State<PassStatus> {
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
                Container(
                  width: 150.w,
                  height: 150.h,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff7574A0),
                    child: Image.asset('lib/assets/images/wynk_pass/white_wynk.png',width: 120.w,height:70.h ,),
                  ),
                ),
                SizedBox(height: 20.h,),
                Text(context.read<PassSubDetails>().passName!,style: TextStyle(color: Colors.black,
                    fontSize: 30.sp,fontWeight: FontWeight.w500),),
                SizedBox(height: 8.h,),
                Text('Expires in ${context.read<PassSubDetails>().currentPassDur!}',style: TextStyle(color: Colors.black,
                    fontSize: 15.sp, fontWeight: FontWeight.w600),),
                SizedBox(height: 100.h,),
                Text('Select a Plan to purchase or renew',style: TextStyle(color: Colors.black,
                    fontSize: 18.sp, fontWeight: FontWeight.w500),),
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