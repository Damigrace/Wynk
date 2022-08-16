import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/registration_feature/confirm_pin.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
String? userTpin;
class CreateTPin extends StatelessWidget {

 const CreateTPin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: backButton(context),
              ),
              Text('Create Your Pin',style: kTextStyle1),
              Text('Keep this number safe, its how you will authorize transactions  ',style: kTextStyle5),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin:  EdgeInsets.only(top: 71.h,),
                  height: 61.h,
                  width: 260.w,
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(7),),
                  child: PinCodeTextField(
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
                    controller: transactionPinController,
                    onCompleted: (v) {
                      userTpin=v;
                      print(userTpin);
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
              Container(
                margin:  EdgeInsets.only(top: 90.h,),
                height: 51.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: kBlue
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>  ConfirmTPin()));
                  },
                  child: Text('Continue',style:kTextStyle2,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
