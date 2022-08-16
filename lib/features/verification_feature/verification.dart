import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';
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
  int? seconds=59;
  int? minutes=2;
  timer()async{
    timeOut=false;
   for (int j=2;j!=-1;j--){
     setState(() {
       minutes=j;
     });
     for (int i=59;i!=-1;i--){
       await Future.delayed(Duration(seconds: 1));
       setState(() {
         seconds=i;
       });
     }

   }
   timeOut=true;
  }
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
  String? userLastFourD;
  bool? timeOut;
  String? otp;
  String? userInputOtpPin;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInputOtpPin='';
     timer();
    String? userNum=context.read<FirstData>().userNumber;
    userLastFourD=userNum!.substring(userNum.length-4);
  }
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                    Text('Please enter the 4-digit verification code sent to your phone number ending in $userLastFourD',
                      style: TextStyle(fontSize: 15.sp),),
                    Padding(
                      padding:  EdgeInsets.only(top: 34.h,bottom: 25.h),
                      child: Container(alignment: Alignment.center,
                          height: 61.h,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(7),),
                          child:PinCodeTextField(
                            autoDisposeControllers: false,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            controller: textEditingController,
                            onCompleted: (v) {
                              userInputOtpPin=v;
                              print(userInputOtpPin);
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            }, appContext: context,
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Code expires in $minutes : $seconds ',
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
                        onPressed: () async {
                          FocusScope.of(context).dispose();
                          setState(() {
                            showSpinner=true;
                          });
                          Map verificationResult = await doOtpVerification(otp: userInputOtpPin,uniqueId:context.read<FirstData>().uniqueId );
                          print(context.read<FirstData>().uniqueId);
                          String statusCode=verificationResult['statusCode'].toString();
                          if(timeOut==false && statusCode=='200'){
                            showToast('OTP successfully verified!');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                const SignUp()));
                          }
                          else if(timeOut==true){print('time out');}
                          else if(statusCode!='200'){
                            showToast('Incorrect OTP!');

                            print('Something is Wrong');}
                         setState(() {
                           showSpinner=false;
                         });
                        },
                        child: Text('Continue',style:kTextStyle2,),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Didn\'t receive any',
                          style: kTextStyle2),
                        TextButton(
                            onPressed: (){},
                            child: Text('Code?',
                              style: kTextStyle2.copyWith(color: kYellow),))
                      ],
                    ),
                  ],),
              ),
            ),
          ),
        ),
      ),
    );
  }
}