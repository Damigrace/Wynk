import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infobip_rtc/api/listeners.dart';
import 'package:infobip_rtc/model/requests.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wynk/features/registration_feature/tandc.dart';
import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
import '../login_feature/login_page.dart';
import '../verification_feature/verification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
int? otp;
class _RegisterPageState extends State<RegisterPage> {

  showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  int? seconds=20;
  timer()async{
     for (int i=20;i!=-1;i--){
       await Future.delayed(Duration(seconds: 1));
       setState(() {
         seconds=i;
       });
     }
     showToast('Oops! This is process is taking more than expected,\n Check your internet connection');
  }


  void gotoVerScreen(){Navigator.push(context, MaterialPageRoute(builder: (context)=>
  const Verification()
  ));}
  String? get user=>Provider.of<FirstData>(context).userNumber;
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  int selectedV=0;

  CallEventListener? callEventListener;

  // void infobipR()async{
  //   final callRequest = CallRequest('wedcvsjch', destination, callEventListener!);
  //   final outgoingCall = await InfobipRTC.call(callRequest);
  // }

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
                 backButton(context),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 35.h,top: 33.h),
                    child: Text('Let\'s get\nstarted',
                      style: kTextStyle1),
                  ),
                  Container(
                    height: 71.h,
                    margin: const EdgeInsets.only(top: 9),
                    child: phoneField()
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 268.h,bottom: 24.h),
                    child: Row(children: [
                      Radio<int>(
                        activeColor: kYellow,
                      toggleable: true,
                      onChanged: (value) {
                        setState(() {
                          if(selectedV==0){selectedV=1;}else{selectedV=0;}
                        });
                      }, groupValue: selectedV, value: 1,

                    ),
                      Text('I accept Wynk\'s',style: TextStyle(fontSize: 15.sp),),
                      TextButton(onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>  TandC()
                        ));
                      }, child: Text('Terms & Conditions',
                          style: TextStyle(fontSize: 15.sp,color: kYellow)))
                    ],),
                  ),
                  SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue
                      ),
                      onPressed:  context.read<FirstData>().numComplete==false||selectedV==0?null:()async{
                        spinner(context);
                        String userNumber='${context.read<FirstData>().numCode!}${userNumLogController.text}';
                        context.read<FirstData>().getUserNumber(userNumber.substring(1));
                        String? userMobileNo =context.read<FirstData>().userNumber;
                        Map sentOtpUser=await sendUserMobileforOtp(userMobileNo: userMobileNo!);
                        showSnackBar(context, sentOtpUser['message']);
                        context.read<FirstData>().getOtpNumberFromServer(sentOtpUser['otp'].toString());
                        print(context.read<FirstData>().otpNumFromServer);
                        context.read<FirstData>().saveUniqueId(sentOtpUser['wynkid'].toString());
                        print(context.read<FirstData>().uniqueId);
                        Navigator.pop(context);
                        gotoVerScreen();

                      },
                      child: Text('Register',style: TextStyle(fontSize: 18.sp),),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 46.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already a user?',style: TextStyle(fontSize: 20.sp),),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          const LoginPage()
                          ));
                        }, child: Text('Login',
                            style: TextStyle(
                                fontSize: 20.sp,
                                color:kYellow)))
                      ],),
                  )
                ],),
            ),
          ),
        ),
      ),
    );
  }
}
