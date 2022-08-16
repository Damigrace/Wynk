import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:   EdgeInsets.only(top:15.h,left:36.w ,right: 36.w),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 36.h,width: 36.h,
                    decoration: BoxDecoration(
                        color: kBlue,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: GestureDetector(
                      child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30.w,),
                      onTap: ()=>Navigator.pop(context),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 28.h,top: 33.h),
                    child: SizedBox(
                        height: 70.h,
                        width: 141.w,
                        child: Text('Reset your password',style: kTextStyle1)),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 24.h,top: 9.h),
                    child:Flex(
                      direction: Axis.horizontal,
                      children: [ InputBox(hintText: 'Email Adress or Phone Number', controller: emailphoneController, textInputType: TextInputType.emailAddress,)], )
                  ),
                  SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary:kBlue
                      ),
                      onPressed: (){},// Method that handles 'reset password' functionality will be added here.
                      child: Text('Reset password',style: TextStyle(fontSize: 15.sp),),
                    ),
                  ),

                ],),
            ),
          ),
        ),
      ),
    );
  }
}