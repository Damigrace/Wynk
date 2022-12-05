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
import '../payment_gateway.dart';
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
            onPressed: (context.read<FirstData>().fromWallet == ''
                || sendFundsAmountCont.text == ''
                || sendFundsWynkid.text == ''
            )?null:() async {
              context.read<FirstData>().savePayRoute('w2w');
              context.read<PaymentData>().saveToWallet(sendFundsVaultNumCont.text);
              context.read<PaymentData>().saveAmount(sendFundsAmountCont.text);
              paymentConfirm(
                  context,
                  sendFundsAmountCont.text,
                  'Funds transfer'
              );

            },
            child: Text('Transfer',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
          ),
        ),
      ],);
  }
}
