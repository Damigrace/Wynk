import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
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
String? userConfirmTpin;
class AnotherUserLogin extends StatefulWidget {

  const AnotherUserLogin({Key? key}) : super(key: key);
  @override
  State<AnotherUserLogin> createState() => _AnotherUserLoginState();
}

class _AnotherUserLoginState extends State<AnotherUserLogin> {
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
                      child: Text( 'Welcome',style: kTextStyle1,)),
                  SizedBox(height: 26.h,),
                  SizedBox(height: 10.h,),
                  Container(
                    height: 71.h,
                    margin: const EdgeInsets.only(top: 9),
                    child: IntlPhoneField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      autofocus: true,
                      controller: userNumLogController,
                      autovalidateMode: AutovalidateMode.disabled,
                      flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration:  InputDecoration(
                        hintText: '8101234567',
                        errorText: errorT,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        counter: const Offstage(),
                        labelText: 'Mobile Number',
                        labelStyle: const TextStyle(color: Color(0xffAFAFB6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'NG',
                      showDropdownIcon: true,
                      dropdownIconPosition:IconPosition.trailing,
                      onChanged: (phone) {
                        setState(() {
                          if (userNumLogController.text.length<10){
                            setState(() {
                              errorT = 'Number Too Short';
                              numComplete=false;
                            });
                          }
                          else{
                            FocusScope.of(context).nextFocus();
                            numComplete=true;
                            errorT = null;}
                        });
                        numCode=phone.countryCode;
                      },
                    ),
                  ),
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
                          setState(() {
                            showSpinner=true;
                          });

                          final prefs = await SharedPreferences.getInstance();

                          try {
                            print(userConfirmTpin);
                            Map loginResponse =
                            await sendLoginDetails(pin: userConfirmTpin!,numCode: numCode);
                            print('$userConfirmTpin,   2');
                            fullnameCont.text = loginResponse['name'];
                            emailController.text = loginResponse['email'];
                            confirmationPhoneCont.text = loginResponse['phone'];
                            prefs.setString('Origwynkid',loginResponse['username']);
                            if(loginResponse['statusCode']==200){
                               final userDet = await getUserRegisteredDetails(wynkId: loginResponse['username']);
                              context.read<FirstData>().getUserP(prefs.getString('userPic'));
                              context.read<FirstData>().getUsername(userDet['firstname']);
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

