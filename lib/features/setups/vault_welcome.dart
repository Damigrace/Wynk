import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
import '../../utilities/models/otp_field.dart';
class VaultWelcome extends StatefulWidget {
  const VaultWelcome({Key? key}) : super(key: key);

  @override
  State<VaultWelcome> createState() => _VaultWelcomeState();
}

class _VaultWelcomeState extends State<VaultWelcome> {

  String? otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: 9.h),
                  child:const UserTopBar()
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 6.h,top: 33.h,left: 26.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Welcome to your',style: TextStyle(fontSize:32.sp,color: Colors.black,fontWeight: FontWeight.w400),),
                    Text('WynkVault!',style: TextStyle(fontSize:32.sp,color:kBlue,fontWeight: FontWeight.w400),),
                  ],)
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 26.w),
                  child: SizedBox(
                    width: 290.w,
                    child: Text('Keep this number safe,it\'s how you will authorize transaction',
                      style: TextStyle(fontSize: 15.sp,color: Colors.grey),),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 70.h,bottom: 25.h,left: 60.w,),
                  child: Form(child:
                  Container(width: 271.w,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        otpField(textEditingController: fieldOne, last: false,first: true,),
                        otpField(textEditingController: fieldTwo,first: false,last: false,),
                        otpField(textEditingController: fieldThree,first: false,last: false,),
                        otpField(textEditingController: fieldFour,first: false,last: true,),
                      ],),
                  )),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 36.w,right: 35.w,top: 90.h),
                  child: SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary:kBlue
                      ),
                      onPressed: (){
                      },
                      child: Text('Continue',style: TextStyle(fontSize: 15.sp),),
                    ),
                  ),
                ),
              ],),
          ),
        ),
      ),
    );
  }
}
