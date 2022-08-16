import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/registration_feature/register_page.dart';
import 'package:untitled/features/registration_feature/signup_camera_permission.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../utilities/models/data_confirmation.dart';
import 'another_user_login.dart';
String? userConfirmTpin;
class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   String? text;
  bool showSpinner=false;
   String? numCode;
   bool numComplete=false;
   int selectedV=0;
   String? errorT;
 @override
  void dispose() {
   confirmTPinController.clear();
   super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    text=context.read<FirstData>().username?.toLowerCase();
    // Uint8List? pic=base64Decode(context.read<FirstData>().userP.toString());
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(color: kBlue,),
          inAsyncCall: showSpinner,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(context),
                  SizedBox(height: 55.h,),
                   Align(
                     alignment: Alignment.center,
                     child: SizedBox(height: 111.h,width: 111.h,child:
                     CircleAvatar(backgroundColor:kBlue
                      ,),),
                   ),
                  SizedBox(height: 10.h,),
                  Align(
                      alignment: Alignment.center,
                      child: Text( 'Welcome back ${text?.replaceFirst(text![0], text![0].toUpperCase())??'User'}',style: kTextStyle1,)),
                  SizedBox(height: 36.h,),
                  Align(
                      alignment: Alignment.center,
                      child: Text('Please Enter Your PIN',style: kTextStyle4,)),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
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
                        controller: confirmTPinController,
                        onCompleted: (v) async{
                          userConfirmTpin=v;
                          print(userConfirmTpin);
                          setState(() {
                            showSpinner=true;
                          });

                            final prefs = await SharedPreferences.getInstance();
                            try {
                              Map loginResponse =
                                  await sendLoginDetails(pin: userConfirmTpin!);
                              fullnameCont.text = loginResponse['name'];
                              emailController.text = loginResponse['email'];
                              confirmationPhoneCont.text = loginResponse['phone'];
                               prefs.setString('Origwynkid',loginResponse['username']);
                              if(loginResponse['statusCode']==200){
                                await getUserRegisteredDetails(wynkId: loginResponse['username']);
                                print('correct');
                                setState(() {
                                  showSpinner=false;
                                });
                                FocusScope.of(context).dispose();
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) =>  HomeMain14()));}

                              else if(loginResponse['statusCode']!=200){
                                setState(() {
                                  showSpinner=false;
                                });
                                print('incorrect');
                                showToast('It seems you entered a wrong pin! Try again.');}
                            }
                             catch(e) {
                               showSpinner = false;
                               setState(() {});
                               confirmTPinController.clear();
                             }
                        }
                        ,
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        }, appContext: context,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(child: Text('Forgot Your PIN?',style: TextStyle(color: kBlue),),onPressed: (){},),
                      TextButton(
                        child: Text('Register',style: TextStyle(color:  kBlue,fontSize: 15.sp),),onPressed: (){
                        Get.to(()=>
                        const RegisterPage(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
                      },),
                    ],
                  ),

                  Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text('Having trouble logging in?',style: TextStyle(color:  kYellow,fontSize: 15.sp),),onPressed: (){
                        Get.to(()=>
                        const AnotherUserLogin(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
                      },)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

