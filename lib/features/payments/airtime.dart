import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/main.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import 'airtime_payment_gateway.dart';
class Airtime extends StatefulWidget {
  const Airtime({Key? key}) : super(key: key);

  @override
  _AirtimeState createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {
  String? pin;

  Color mtnCol = Colors.white;
  Color gloCol = Colors.white;
  Color airtelCol = Colors.white;
  Color mob9Col = Colors.white;
  double mtnOPa = 0.1;
  double gloOPa = 0.1;
  double airtelOPa = 0.1;
  double mob9OPa = 0.1;
  @override
  Widget build(BuildContext context) {
    switch(context.watch<FirstData>().selectedNetwork){
      case 1 : mtnCol = kBlue;mtnOPa = 1;break;
      case 2 : mob9Col = kBlue;mob9OPa = 1;break;
      case 3 : gloCol = kBlue;gloOPa = 1;break;
      case 4 : airtelCol = kBlue;airtelOPa = 1;
    }
    return Scaffold(body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 36.w,vertical: 77.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 31.h,),
                Text('Mobile\nRecharge',style: TextStyle(fontSize: 26.sp),),
                Container(
                    margin: EdgeInsets.only(bottom: 32.h,top: 33.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 61.h,
                    width: 326.w,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(Icons.search,color: kGrey1,),
                          SizedBox(width: 15.w,),
                          Expanded(
                            child: TextField(
                              maxLines:1 ,
                              cursorHeight: 0,
                              cursorWidth: 0,
                              onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                              autofocus: true,
                              keyboardType:TextInputType.text,
                              style: TextStyle(fontSize: 15.sp,),
                              decoration:   InputDecoration.collapsed(
                                  hintText:  'Enter to start searching',
                                  hintStyle:  TextStyle(fontSize: 15.sp,
                                      color: kBlack1
                                  )),),
                          ),
                        ],
                      ),
                    )
                ),
                Text('Select Network',style: TextStyle(fontSize: 12.5.sp),),
                SizedBox(height: 15.h,),
                SizedBox(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Opacity(
                        opacity: mtnOPa,
                        child: Container(
                            child: Image.asset('lib/assets/images/airtime_logo/mtn.png'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: mtnCol,width: 2)
                          ),

                        ),
                      ),
                      SizedBox(width: 4.w,),
                      Opacity(
                        opacity: mob9OPa,
                        child: Container(
                          child:  Image.asset('lib/assets/images/airtime_logo/9mobile.png'),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: mob9Col,width: 2)
                          ),

                        ),
                      ),
                      SizedBox(width: 4.w,),
                      Opacity(
                        opacity: gloOPa,
                        child: Container(
                          child: Image.asset('lib/assets/images/airtime_logo/glo.png'),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: gloCol,width: 2)
                          ),

                        ),
                      ),
                      SizedBox(width: 4.w,),
                      Opacity(
                        opacity: airtelOPa,
                        child: Container(
                          child: Image.asset('lib/assets/images/airtime_logo/airtel.png'),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: airtelCol,width: 2)
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 33.h,),
                Text('Phone Number',style: TextStyle(fontSize: 12.5.sp),),
                Container(
                    margin: EdgeInsets.only(bottom: 26.h,top: 17.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 61.h,
                    width: 326.w,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines:1 ,
                            cursorHeight: 0,
                            cursorWidth: 0,
                            onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                            autofocus: true,
                            keyboardType:TextInputType.text,
                            style: TextStyle(fontSize: 15.sp,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Enter 11 digit phone number',
                                hintStyle:  TextStyle(fontSize: 15.sp,
                                    color: kBlack1
                                )),),
                        ),
                      ],
                    )
                ),
                Text('Amount',style: TextStyle(fontSize: 12.5.sp),),
                Container(
                    margin: EdgeInsets.only(bottom: 26.h,top: 17.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 61.h,
                    width: 326.w,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines:1 ,
                            cursorHeight: 0,
                            cursorWidth: 0,
                            onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                            autofocus: true,
                            keyboardType:TextInputType.text,
                            style: TextStyle(fontSize: 15.sp,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Minimum:NGN 500',
                                hintStyle:  TextStyle(fontSize: 15.sp,
                                    color: kBlack1
                                )),),
                        ),
                      ],
                    )
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50.h,
                    width: 318.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kBlue),
                      onPressed: () async{
                        await showDialog(
                            barrierDismissible: false,
                            context: context, builder: (context){
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(30.w),
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                            content: Container(
                              width: 301.w,
                              height:270.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text('Enter PIN',
                                        style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
                                      SizedBox(height: 13.h,),
                                      Text('Enter your 4-digit PIN to authorise \nthis transaction.',
                                        style: TextStyle(fontSize: 10.sp)),
                                    ],),
                                    GestureDetector(
                                      onTap: ()=>Navigator.pop(context),
                                      child: SizedBox(
                                          width: 42.w,
                                          height: 42.w,
                                          child: Image.asset('lib/assets/images/rides/cancel1.png')),
                                    )
                                  ],),

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
                                        controller: transactionPinController,
                                        onCompleted: (v) async{
                                          pin=v;
                                          Navigator.pop(context);

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
                                  SizedBox(height:47.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50.h,
                                      width: 241.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kBlue),
                                        onPressed: ()  {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentGateway(
                                                        function: (){
                                                          Navigator.pop(context);
                                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                              Airtime()));
                                                        },
                                                      )));
                                        },
                                        child: Text('Confirm',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      child: Text('Pay',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],),
    ));
  }
}
