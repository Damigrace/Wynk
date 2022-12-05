import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/models/lists.dart';
import '../../utilities/widgets.dart';
import 'payment_gateway.dart';
class PowerUtilityMain extends StatefulWidget {
  const PowerUtilityMain({Key? key}) : super(key: key);

  @override
  _PowerUtilityMainState createState() => _PowerUtilityMainState();
}

class _PowerUtilityMainState extends State<PowerUtilityMain> {
  String? pin;

  String? selectedIDType;

  String? meterNum;

  String? amount;

   int? selectedWallet;

  String? fromWallet;

  bool nairaIsVisible = false;

  bool pay = false;

  String? pCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 36.w,right:36.w,top: 77.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 31.h,),
                Text('Power\nUtility',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 37.h,),
                Text('Select  Package',style: TextStyle(fontSize: 12.5.sp),),
                SizedBox(height: 14.h,),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children:  [
                          Expanded(
                            child: Text('Package type',
                                style:kBoldGrey,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      items:packages.map((package) => DropdownMenuItem<String>(
                          value: package,
                          child: Text(
                            package,
                            style: kBoldBlack,
                            overflow: TextOverflow.ellipsis,
                          ))).toList(),
                      value: selectedIDType,
                      onChanged: (value){

                        setState(() {
                          selectedIDType=value as String;
                        });
                      },
                      icon: const Icon(
                          Icons.keyboard_arrow_down_sharp
                      ),
                      iconSize: 30.h,
                      iconEnabledColor: kGrey1,
                      iconDisabledColor:kGrey1,
                      buttonHeight: 51.h,
                      buttonWidth: double.infinity,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: Colors.black26),
                          color: kWhite),
                      buttonElevation: 0,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color:kWhite),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0)),
                ),
                SizedBox(height: 10.h,),
                Text('Meter Number',style: TextStyle(fontSize: 12.5.sp),),
                Container(
                    margin: EdgeInsets.only(bottom: 10.h,top: 14.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 51.h,
                    width: 318.w,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines:1 ,
                              cursorHeight: 0,
                              cursorWidth: 0,
                              onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                              autofocus: true,
                              onChanged: (val){
                                meterNum = val;
                              },
                              keyboardType:TextInputType.number,
                              style: kBoldBlack,
                              decoration:   InputDecoration.collapsed(
                                  hintText:  'Enter your meter number',
                                  hintStyle:  kBoldGrey
                              ),),
                          ),
                        ],
                      ),
                    )
                ),
                Text('Select wallet',style: TextStyle(fontSize: 12.5.sp),),
                WalletCont(),
                Text('Amount',style: TextStyle(fontSize: 12.5.sp),),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 51.h,
                    width: 326.w,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Row(
                      children: [
                        Visibility(
                          child: Text('₦', style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),),
                          visible: nairaIsVisible,
                        ),
                        Expanded(
                          child: TextField(
                            maxLines:1 ,
                            cursorHeight: 0,
                            cursorWidth: 0,
                            autofocus: true,
                            inputFormatters: [ThousandsFormatter(allowFraction: true)],
                            onChanged: (val){
                              if(selectedIDType != null &&
                              meterNum != null &&
                              context.read<FirstData>().fromWallet != null &&
                              subscribeAmountCont.text != ''
                              ){
                                setState(() {
                                  pay = true;
                                });
                              }
                              if(subscribeAmountCont.text == ''){
                                setState(() {
                                  nairaIsVisible = false;
                                });
                              }
                              else{
                                setState(() {
                                  nairaIsVisible = true;
                                });
                              }
                            },
                            controller: subscribeAmountCont,
                            keyboardType:TextInputType.number,
                            style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Minimum of ₦‎ 2,000',
                                hintStyle:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,
                                    color: kBlack1
                                )),),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20.h,),
                Text('You will be charged a fee of ₦‎ 120 for \nthis transaction.',
                  style: TextStyle(fontSize: 12.5.sp,color: Colors.red),),
                SizedBox(height: 20.h,),
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue),
                    onPressed: (pay == false)?null:() async {
                      spinner(context);
                      final res = await lookupPower(
                          meterNum!,
                          selectedIDType!, context.read<FirstData>().fromWallet!,
                          subscribeAmountCont.text, context.read<FirstData>().serviceUnit!);
                      if(res['statusCode'] == 200){
                        pCode = res['data']['data']['productCode'];
                        Navigator.pop(context);
                        await showDialog(
                            barrierDismissible: false,
                            context: context, builder: (context){
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(10.w),
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                            content: Container(
                              width: 301.w,
                              // height:270.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Confirm Information',
                                        style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
                                      SizedBox(height: 13.h,),
                                      Text('Please review the information below before proceeding',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12.sp,color: kYellow)),
                                      SizedBox(height: 30.h,),
                                    ],),
                                  Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Name',style: TextStyle(fontSize: 15.sp),),
                                        Text(res['data']['data']['name'],style: TextStyle(fontWeight: FontWeight.w600))
                                      ],),
                                    SizedBox(height:10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(child: Text('Meter No.',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 15.sp),)),
                                        SizedBox(width: 10.w),
                                        Text(res['data']['data']['meterNumber']??'', style: TextStyle(fontWeight: FontWeight.w600))
                                      ],),
                                    SizedBox(height:10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(child: Text('B/Unit',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 15.sp),)),
                                        SizedBox(width: 10.w),
                                        Text(res['data']['data']['businessUnit']??'', style: TextStyle(fontWeight: FontWeight.w600))
                                      ],)
                                  ],),
                                  SizedBox(height:47.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50.h,
                                      width: 318.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kBlue),
                                        onPressed: pay == false?null:() async{
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
                                                // height:270.h,
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
                                                        margin:  EdgeInsets.only(top: 20.h),
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
                                                          onCompleted: (value) async{
                                                            pin = value;
                                                          },
                                                          beforeTextPaste: (text) {
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
                                                              backgroundColor: kBlue),
                                                          onPressed: ()  async{
                                                            spinner(context);
                                                            Map loginResponse = await sendLoginDetails(pin: transactionPinController.text);
                                                            transactionPinController.clear();
                                                            if(loginResponse['statusCode'] != 200){
                                                              Navigator.pop(context);
                                                              showSnackBar(context,'Incorrect Transaction Pin');
                                                            }
                                                            else{
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PaymentGateway(
                                                                            future: purchasePower(
                                                                                'shortname',
                                                                                'cRef',
                                                                                context.read<FirstData>().fromWallet!,
                                                                                subscribeAmountCont.text,
                                                                                pCode!
                                                                            ),

                                                                            function: (){
                                                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                                                  PowerUtilityMain()));
                                                                            }, amount:subscribeAmountCont.text,
                                                                            purpose: '' ,
                                                                          )));
                                                            }
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
                          );
                        });
                      }
                      else{
                        Navigator.pop(context);
                        Future.delayed(Duration(milliseconds: 5),(){
                          showSnackBar(context, res['errorMessage']);});
                      }
                    },
                    child: Text('Next',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],),),);
  }
}
