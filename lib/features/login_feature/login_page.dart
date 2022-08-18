
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import '../firebase/ride_schedule.dart';
import '../landing_pages/welcome_page.dart';
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
   super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    text=context.read<FirstData>().username?.toLowerCase();

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                       CircleAvatar(
                           backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),
                       ),),
                     ),
                    SizedBox(height: 10.h,),
                    Align(
                        alignment: Alignment.center,
                        child: Text( 'Welcome back ${text?.replaceFirst(text![0], text![0].toUpperCase())??'User'}',textAlign: TextAlign.center,
                          style: kTextStyle1,)),
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
                          controller: loginPinCont,
                          onCompleted: (v) async{
                            userConfirmTpin=v;
                            print(userConfirmTpin);
                            showDialog(context: context, builder: (context)=>
                                Center(
                                  child: Container(decoration: BoxDecoration(
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
                              prefs.setString('mypin',loginPinCont.text);
                              try {
                                Map loginResponse = await sendLoginDetails(pin: userConfirmTpin!);
                                if(loginResponse['statusCode'] != 200){
                                  Navigator.pop(context);
                                  showToast(loginResponse['errorMessage']);
                                }
                                else{
                                  fullnameCont.text = loginResponse['name'];
                                  emailController.text = loginResponse['email'];
                                  confirmationPhoneCont.text = loginResponse['phone'];
                                  prefs.setString('Origwynkid',loginResponse['username']);
                                    context.read<FirstData>().saveShowLoginNotif(true);
                                    loginPinCont.clear();
                                    print('transitioning');
                                    Get.to(()=>HomeMain14(),transition: Transition.circularReveal,
                                        duration: Duration(milliseconds: 500));
                                }
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
                        TextButton(child: Text('Forgot Your PIN?',style: TextStyle(color: kBlue),),onPressed: ()async{
                          // await FlutterPhoneDirectCaller.callNumber(number);
                         // RideSchedule('tade','2').test()
                        },),
                        TextButton(
                          child: Text('Register',style: TextStyle(color:  kYellow),),onPressed: (){
                          Get.to(()=>
                          const RegisterPage(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
                        },),
                      ],
                    ),

                    Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text('Log in with  mobile number',style: TextStyle(color:  kYellow,fontSize: 15.sp),),onPressed: (){
                            // infobipCall();
                            // showNotification();
                          Get.to(()=>
                          const AnotherUserLogin(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
                        },)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

