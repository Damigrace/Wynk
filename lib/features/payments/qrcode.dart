import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/payments/airtime_topup.dart';
import 'package:untitled/features/payments/payment_list.dart';
import 'package:untitled/features/payments/request_funds/req_funds.dart';
import 'package:untitled/features/payments/send_funds/data_topup.dart';
import 'package:untitled/features/payments/send_funds/send_to_bank.dart';
import 'package:untitled/features/payments/send_funds/send_to_wynk.dart';
import 'package:untitled/features/payments/send_funds/sendcash.dart';
import 'package:untitled/services.dart';

import '../../../utilities/constants/colors.dart';
import '../../../utilities/widgets.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  String? walletName;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          body:
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 36.w,vertical: 77.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        backButton(context),
                      ],),
                    SizedBox(height: 31.h,),
                    Text('Use QR Code',style: TextStyle(fontSize: 26.sp),),
                    SizedBox(height: 40.h,),
                    Container(
                      height: 51.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.w),
                        color: kGrey1,
                      ),

                      child: GestureDetector(
                        onTap:()async{
                          String res = await FlutterBarcodeScanner.scanBarcode(
                              '#F98611', 'Cancel', true, ScanMode.QR) ;
                          final res0 =await jsonDecode(res);
                          sendFundsVaultNumCont.text = res0['vault'];
                          sendFundsWynkid.text = res0['wynkid'];
                          sendFundsAmountCont.text = res0['amount'];
                          Future.delayed(Duration(milliseconds: 500),()async{
                            spinner(context);
                            final res = await walletLookup(res0['vault']);
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
                                              Text(res0['vault'],style: TextStyle(fontWeight: FontWeight.w600))
                                            ],),
                                          SizedBox(height:10.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(child: Text('Vault name',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 15.sp),)),
                                              SizedBox(width: 10.w),
                                              Text(walletName!??'', style: TextStyle(fontWeight: FontWeight.w600))
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
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>SendCash()),);
                        },
                        child:Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.w),
                                color:  kBlue
                            ),
                            alignment: Alignment.center,
                            height: double.infinity,
                            child: Text('Scan Code',style: TextStyle(
                                color: Colors.white,
                                fontSize:18.sp,fontWeight: FontWeight.w600 ),)),
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Container(
                      height: 51.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.w),
                        color: kBlue,
                      ),

                      child: GestureDetector(
                        onTap:(){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>RequestFunds()),);
                        },
                        child:Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kBlue),
                                borderRadius: BorderRadius.circular(5.w),
                                color:  Colors.white
                            ),
                            alignment: Alignment.center,
                            height: double.infinity,
                            child: Text('Generate Code',style: TextStyle(
                                color: Colors.black,
                                fontSize:18.sp,fontWeight: FontWeight.w600 ),)),
                      ),
                    ),
                  ],
                ),
              ),
            ],)
      ),
    );
  }
}

