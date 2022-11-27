import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wynk/features/wynk-pass/pass_purchase_success.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class PassPurchasePin extends StatefulWidget {
   PassPurchasePin({Key? key}) : super(key: key);
  @override
  _PassPurchasePinState createState() => _PassPurchasePinState();
}

class _PassPurchasePinState extends State<PassPurchasePin> {
  String? inputPin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 15.w,top: 10.h,right: 7.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 26.r,
                            backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),
                            child:Container(),
                          ),
                          Text(context.watch<FirstData>().userType == '2'?'Capt. ${
                              context.watch<FirstData>().user}'
                              :context.watch<FirstData>().user??'',style: TextStyle(fontSize: 20.sp)),
                        ],
                      ),
                    ),
                   backButton(context),
                  ],),
              ),
              SizedBox(height: 83.h,),
              Text('Please Enter Your PIN',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.w600),),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin:  EdgeInsets.only(top: 74.h),
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
                    controller: inputVaultPin,
                    onCompleted: (v) async{
                      inputPin=v;
                      print(inputPin);
                      showDialog(
                          barrierDismissible: false,
                          context: context, builder: (context){
                        return Container(child:
                        SpinKitCircle(
                          color: kYellow,
                        ),);});
                      Map loginResponse = await sendLoginDetails(pin: inputPin!);
                      inputVaultPin.clear();
                      if(loginResponse['statusCode'] != 200){

                        Navigator.pop(context);
                        showToast('Incorrect Transaction Pin');
                      }
                      else{
                        final passPaymentStat = await payForPass(passId: context.read<PassSubDetails>().passId!);
                        if(passPaymentStat['statusCode'] == 200){
                          context.read<FirstData>().saveUserType('2');
                          context.read<FirstData>().saveOriguser('2');
                          showSnackBar(context,passPaymentStat['errorMessage']);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchaseConfirm()));
                        }
                        else{
                          Navigator.pop(context);
                          showToast(passPaymentStat['errorMessage']);
                        }
                      }
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
              Flexible(child: SizedBox(height: 179.h,)),
              SizedBox(height: 10.h,),
            ],),
        ),
      ),
    );
  }


}
Widget WhiteWynkPass(String price ) {

  return Container(
    child: Container(
      width: 144.w,
      height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: Color(0xff7574A0),
              child: Image.asset('lib/assets/images/wynk_pass/white_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text('Daily',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 3.h,),
          Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 10.h,),
          Text('Valid for 24 hours',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: kBlue),
              onPressed: ()async{

              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],
      ),
    ),
  );
}

Container BlueWynkPass (String price){
  return Container(
    child: Container(
      width: 144.w,
      height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: kYellow,
              child: Image.asset('lib/assets/images/wynk_pass/blue_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text('Weekly',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 3.h,),
          Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 10.h,),
          Text('Valid for 7 days',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  primary: kBlue),
              onPressed: ()async{
              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],
      ),
    ),
  );
}

Container YellowWynkPass (String price){
  return Container(
    child: Container(
      width: 144.w,
      height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: kBlue,
              child: Image.asset('lib/assets/images/wynk_pass/yellow_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text('Monthly',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 3.h,),
          Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 10.h,),
          Text('Valid for 30 days',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: kBlue),
              onPressed: ()async{
              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],
      ),
    ),
  );
}