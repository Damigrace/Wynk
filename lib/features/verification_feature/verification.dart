import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../controllers.dart';
import '../../utilities/models/otp_field.dart';
import '../registration_feature/sign_up.dart';
class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String? otp;
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
                    padding:  EdgeInsets.only(bottom: 26.h,top: 33.h),
                    child: Text('Verification',style: kTextStyle1),
                  ),
                  Text('Please enter the 4-digit verification code sent to your phone number ending in 8765',
                    style: TextStyle(fontSize: 15.sp),),
                  Padding(
                    padding:  EdgeInsets.only(top: 34.h,bottom: 25.h),
                    child: Container(
                        height: 61.h,
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(7),),
                        child:Form(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            otpField(textEditingController: fieldOne,),
                            otpField(textEditingController: fieldTwo,),
                            otpField(textEditingController: fieldThree,),
                            otpField(textEditingController: fieldFour,),
                          ],)
                        ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Code expires in 2:59', //the countdown functionality will be addressed soon
                      style: kTextStyle2),
                  ),
                  SizedBox(height: 372.h),
                  SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kBlue
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            const SignUp()
                        ));
                      },
                      child: Text('Continue',style:kTextStyle2,),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Did\'nt receive any',
                        style: kTextStyle2),
                      TextButton(
                          onPressed: (){},
                          child: Text('Code?',
                            style: kTextStyle2,))
                    ],
                  ),
                ],),
            ),
          ),
        ),
      ),
    );
  }
}