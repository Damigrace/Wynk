import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controllers.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class AddFunds5 extends StatelessWidget {
   AddFunds5({Key? key}) : super(key: key);
   String? pin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 27.w,vertical: 41.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(context),
                  SizedBox(height: 66.h,),
                  Text.rich(
                    TextSpan(
                        style: TextStyle(fontSize: 30.sp),
                        text: 'Welcome to your ',
                        children: [
                          TextSpan(text: 'WynkVault!',style: TextStyle(color: kBlue),)
                        ]
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 63.w,top: 16.h,right: 67.w),
                child: Column(children: [
                  Text('Please Enter Your 4-Digit Transaction PIN',
                    style: TextStyle(fontSize: 25.sp),
                  textAlign: TextAlign.center,),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin:  EdgeInsets.only(top: 55.h,bottom: 179.h),
                      height: 61.h,
                      width: 260.w,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(7),),
                      child: PinCodeTextField(
                        showCursor: true,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        autoUnfocus: true,
                        autoDisposeControllers: false,
                        keyboardType: TextInputType.number,
                        onChanged: (v){},
                        autoFocus: true,
                        length: 4,
                        obscureText: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          activeFillColor: kWhite,
                          inactiveFillColor: kWhite,
                          selectedFillColor: kWhite,
                          activeColor: kGrey1,
                          inactiveColor: kGrey1,
                          selectedColor: kGrey1,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 61.h,
                          fieldWidth: 51.w,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        controller: vaultFundingPinController,
                        onCompleted: (v) async{
                         pin = v;
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        }, appContext: context,
                      ),
                    ),
                  ),
                ],)),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50.h,
                width: 318.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue),
                  onPressed: ()  {
                    Navigator.of(context).pushNamed('/AddFundsGateway');
                  },
                  child: Text('Submit',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                ),
              ),
            )
          ],),
      )
    );
  }
}
