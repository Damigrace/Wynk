import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wynk/controllers.dart';
import 'package:wynk/features/payments/airtime_topup.dart';
import 'package:wynk/features/payments/payment_list.dart';
import 'package:wynk/features/payments/send_funds/data_topup.dart';
import 'package:wynk/features/payments/send_funds/send_to_bank.dart';
import 'package:wynk/features/payments/send_funds/send_to_wynk.dart';
import 'package:wynk/services.dart';

import '../../../utilities/constants/colors.dart';
import '../../../utilities/widgets.dart';

class SendCash extends StatefulWidget {
  const SendCash({Key? key}) : super(key: key);

  @override
  _SendCashState createState() => _SendCashState();
}

class _SendCashState extends State<SendCash> {
  int index = 0;
  bool isAirtButPressed = true;
  bool isDatButPressed = false;
  final screens = [
    SendToWynk(),
    SendToBank()
  ];

  String? walletName;
  @override
  void dispose() {
    // TODO: implement deactivate
    sendFundsAmountCont.clear();
    sendFundsVaultNumCont.clear();
    sendFundsWynkid.clear();
    sendFundsNarrationCont.clear();
    selectBankCont.clear();
    accNumberCont.clear();
    selectWalletCont.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: SingleChildScrollView(
      child: Column(
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
                    SizedBox(
                      height: 36.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kYellow),
                        onPressed: () async {
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
                         });
                        },
                        child: Text('Scan QRCode',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                      ),
                    )
                ],),
                SizedBox(height: 31.h,),
                Text('Send Funds',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 10.h,),
                Container(
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.w),
                    color: kGrey1,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:(){
                            setState(() {
                              index = 0;
                              isAirtButPressed = true;
                              isDatButPressed = false;
                            });
                          },
                          child:Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color:  isAirtButPressed == true?kBlue:kGrey1
                              ),
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text('To Wynk',style: TextStyle(
                                  color: Colors.white,
                                  fontSize:18.sp,fontWeight: FontWeight.w600 ),)),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap:(){
                            setState(() {
                              index = 1;
                              isAirtButPressed = false;
                              isDatButPressed = true;
                            });
                          },
                          child:Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color:  isDatButPressed == true?kBlue:kGrey1
                              ),
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text('To Bank',style: TextStyle(
                                  color: Colors.white,
                                  fontSize:18.sp,fontWeight: FontWeight.w600 ))),
                        ),
                      ),

                      // Expanded(
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           elevation: 0,
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(5.w)
                      //           ),
                      //           backgroundColor: isAirtButPressed == true?kBlue:Colors.white),
                      //       onPressed: (){setState(() {
                      //         index = 0;
                      //         isAirtButPressed = true;
                      //         isDatButPressed = false;
                      //       });},
                      //       child: Text('Airtime',style: TextStyle(
                      //       color: isAirtButPressed == true?Colors.white:kGrey1,
                      //           fontSize:18.sp,fontWeight: FontWeight.w600 ),)),
                      // ),


                      // Expanded(
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           elevation: 0,
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(5.w)
                      //           ),
                      //           backgroundColor: isDatButPressed == true?kBlue:Colors.white),
                      //       onPressed: (){
                      //         setState(() {
                      //           index = 1;
                      //           isAirtButPressed = false;
                      //           isDatButPressed = true;
                      //         });
                      //       }, child: Text('Data',style: TextStyle(
                      //       color: isDatButPressed == true?Colors.white:kGrey1,
                      //       fontSize:18.sp,fontWeight: FontWeight.w600 ))),
                      // ),
                    ],),
                ),
                SizedBox(height: 20.h,),
                IndexedStack(
                  children: screens,
                  index: index,
                )


              ],
            ),
          ),
        ],),
    ));
  }
}

