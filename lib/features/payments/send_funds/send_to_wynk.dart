import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wynk/features/payments/send_funds/sendcash.dart';


import '../../../controllers.dart';
import '../../../main.dart';
import '../../../services.dart';
import '../../../utilities/constants/colors.dart';
import '../../../utilities/widgets.dart';
import '../airtime_payment_gateway.dart';
class SendToWynk extends StatefulWidget {
  const SendToWynk({Key? key}) : super(key: key);

  @override
  _SendToWynkState createState() => _SendToWynkState();
}

class _SendToWynkState extends State<SendToWynk> {
  int? selectedWallet;
  String? fromWallet;
  String? walletName;
  String pin = '';

  bool nairaIsVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WalletCont(),
        SizedBox(height: 10.h,),
        Container(
            height: 51.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: kGrey1),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(
                  onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                  onChanged: (val)async{
                    if(val.length == 10){
                      spinner(context);
                      final res = await walletLookup(val);
                      Navigator.pop(context);
                      if(res['statusCode'] == 200){
                        walletName = res['accountName'];
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
                              height:270.h,
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
                                        Text('Vault ID',style: TextStyle(fontSize: 15.sp),),
                                        Text(val,style: TextStyle(fontWeight: FontWeight.w600))
                                      ],),
                                    SizedBox(height:10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(child: Text('Vault name',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 15.sp),)),
                                        SizedBox(width: 10.w),
                                        Text(walletName!, style: TextStyle(fontWeight: FontWeight.w600))
                                      ],)
                                  ],),
                                  SizedBox(height:47.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50.h,
                                      width: 241.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kBlue),
                                        onPressed: ()  async {
                                          sendFundsWynkid.text = res['wynkid'];
                                          Navigator.pop(context);
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
                      }
                      else{
                        showToast('We could not fetch beneficiary details');
                      }
                    }
                  },
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),
                  decoration:   InputDecoration.collapsed(
                      hintText:  'Enter beneficiary\'s vault number',
                      hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                          color: kGrey1
                      )),
                  controller: sendFundsVaultNumCont,),
              )
            ],
            )
        ),
        SizedBox(height: 10.h,),
        SizedBox(height: 10.h,),
        Container(
            height: 51.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: kGrey1),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(
                  autofocus: true,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),
                  decoration:   InputDecoration.collapsed(
                      hintText:  'Beneficiary Wynk ID',
                      hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                          color: kGrey1
                      )),
                  controller: sendFundsWynkid,),
              )
            ],
            )
        ),
        SizedBox(height: 10.h,),
        SizedBox(height: 10.h,),
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
                      if(sendFundsAmountCont.text == ''){
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
                    controller: sendFundsAmountCont,
                    keyboardType:TextInputType.number,
                    style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                    decoration:   InputDecoration.collapsed(
                        hintText:  'Enter Amount',
                        hintStyle:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,
                            color: kBlack1
                        )),),
                ),
              ],
            )
        ),
        SizedBox(height: 10.h,),
        SizedBox(height: 10.h,),
        Container(
            height: 51.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: kGrey1),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(
                  onEditingComplete:()=> FocusScope.of(context).nextFocus(),

                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),
                  decoration:   InputDecoration.collapsed(
                      hintText:  'Narration',
                      hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                          color: kGrey1
                      )),
                  controller: sendFundsNarrationCont,),
              )
            ],
            )
        ),
        SizedBox(height: 20.h,),
        SizedBox(
          height: 50.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kBlue),
            onPressed: () async {
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
                                print('valueeeeeeeeeeeeeeeeeeeee : $value');
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
                                  backgroundColor: kBlue),
                              onPressed: ()  async{
                                spinner(context);
                                Map loginResponse = await sendLoginDetails(pin: pin);
                                transactionPinController.clear();
                                if(loginResponse['statusCode'] != 200){
                                  Navigator.pop(context);
                                  showToast('Incorrect Transaction Pin');
                                }
                                else{
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                      PaymentGateway(
                                        future: wallet2wallet(context.read<FirstData>().fromWallet,
                                            sendFundsVaultNumCont.text, sendFundsAmountCont.text),
                                        function: (){
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                              SendCash()));
                                        }, amount: sendFundsAmountCont.text, purpose: 'funds transfer',
                                      )
                                  ));

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
            child: Text('Transfer',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
          ),
        ),
      ],);
  }
}
