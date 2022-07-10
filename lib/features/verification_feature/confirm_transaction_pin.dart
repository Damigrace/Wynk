import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers.dart';
import '../../utilities/models/otp_field.dart';
import '../../utilities/widgets.dart';
import '../setups/create_transaction_pin.dart';
class ConfirmTransactionPin extends StatefulWidget {
  const ConfirmTransactionPin({Key? key}) : super(key: key);

  @override
  State<ConfirmTransactionPin> createState() => _ConfirmTransactionPinState();
}

class _ConfirmTransactionPinState extends State<ConfirmTransactionPin> {
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
                  child: UserTopBar(),
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 6.h,top: 33.h,left: 26.w),
                  child: Text('Confirm Transaction Pin',style: TextStyle(fontSize:32.sp,color: Colors.black,fontWeight: FontWeight.w400),),
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
                  SizedBox(width: 271.w,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        otpField(textEditingController: fieldOne,),
                        otpField(textEditingController: fieldTwo,),
                        otpField(textEditingController: fieldThree,),
                        otpField(textEditingController: fieldFour,),
                      ],),
                  )),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 36.w,right: 35.w,top: 90.h),
                  child: Container(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff181585)
                      ),
                      onPressed: (){
                      },
                      child: Text('Submit',style: TextStyle(fontSize: 15.sp),),
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

