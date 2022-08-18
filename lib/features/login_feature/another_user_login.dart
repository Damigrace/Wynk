import 'dart:convert';
import 'dart:typed_data';
import 'package:infobip_rtc/infobip_rtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/landing_pages/welcome_page.dart';
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
  int selectedV=0;
  String? errorT;

  var bordCol = kGrey1;
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    text=context.read<FirstData>().username?.toLowerCase();
    // Uint8List? pic=base64Decode(context.read<FirstData>().userP.toString());
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async{
            return  await Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  WelcomePage()));
          },
        child: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(color: kBlue,),
          inAsyncCall: showSpinner,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
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
                      onTap: ()=> Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>  WelcomePage())),
                    ),
                  ),
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
                    child: phoneField()
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
                        controller: confirmAnotherUserPinController,
                        onCompleted: (v) async{
                          userConfirmTpin=v;
                          showDialog(
                            barrierDismissible: false,
                              context: context,
                              builder: (context)=>
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kBlue,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  width: 150.w,
                                  child: Card(
                                    color: kBlue,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 10.h,),
                                        SpinKitCircle(color: kYellow,),
                                        SizedBox(height: 10.h,),
                                        Text('Logging in...',style: TextStyle(color: Colors.white,fontSize: 18.sp),textAlign: TextAlign.center,),
                                        SizedBox(height: 10.h,),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                          final prefs = await SharedPreferences.getInstance();
                          try {
                            print(userConfirmTpin);
                            Map loginResponse = await sendLoginDetails2(pin: userConfirmTpin!,numCode: context.read<FirstData>().numCode);
                            if(loginResponse['statusCode'] == 200){
                              fullnameCont.text = loginResponse['name'];
                              emailController.text = loginResponse['email'];
                              confirmationPhoneCont.text = loginResponse['phone'];
                              prefs.setString('Origwynkid',loginResponse['username']);
                             final userDet = await getUserRegisteredDetails(wynkId: loginResponse['username']);
                              context.read<FirstData>().getUserP(prefs.getString('userPic'));
                              context.read<FirstData>().getUsername(userDet['firstname']);

                              context.read<FirstData>().saveShowLoginNotif(true);
                              prefs.setString('mypin',confirmAnotherUserPinController.text);
                              confirmAnotherUserPinController.clear();
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomeMain14()));
                            }
                            else{
                              Navigator.pop(context);
                              showToast(loginResponse['errorMessage']);
                            }
                          }
                          catch(e) {
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
                      TextButton(child: Text('Forgot Your PIN?',style: TextStyle(color: kBlue),),onPressed: (){
                        //postRequest3(WynkId: 'WYNK77875279');
                      },),
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
        ),)
      ),
    );
  }
}

