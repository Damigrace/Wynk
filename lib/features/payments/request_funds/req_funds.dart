import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../main.dart';
import '../../../utilities/constants/colors.dart';
import '../../../utilities/firebase_dynamic_link.dart';
import '../../../utilities/widgets.dart';

class RequestFunds extends StatefulWidget {
  const RequestFunds({Key? key}) : super(key: key);

  @override
  _RequestFundsState createState() => _RequestFundsState();
}

class _RequestFundsState extends State<RequestFunds> {
  int? selectedWallet;
  String? toWallet;
  String? pin;
  String? res;
  bool nairaIsVisible = false;

  String? wallet;

  ScreenshotController qrShot = ScreenshotController();
  @override
  void dispose() {
    requestFundsAmountCont.clear();
    senderVaultIdController.clear();
    selectWalletCont.clear();
    contactSearchCont.clear();
    // TODO: implement initState
    super.dispose();
  }
  String? newRes;
  void checkContact()async{
    spinner(context);
    final response = await responseFromPhone(newRes!);
    print(response['wynkid']);
    if(response['wynkid'] == null){
      Navigator.pop(context);
      showSnackBar(context,'It seems this contact is not a Wynk user.');
    }
    else{

     final res = await walletLookup(response['wallet_number']);
     Navigator.pop(context);
     if(res['statusCode'] == 200){
       String walletName = res['accountName'];
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
                       Text(wallet!,style: TextStyle(fontWeight: FontWeight.w600))
                     ],),
                   SizedBox(height:10.h),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       SizedBox(child: Text('Vault name',
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontSize: 15.sp),)),
                       SizedBox(width: 10.w),
                       Text(walletName??'', style: TextStyle(fontWeight: FontWeight.w600))
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
       showSnackBar(context,'We could not fetch beneficiary details');
     }
    }
  }
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
                SizedBox(height: 25.h,),
                Text('Request Funds',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 25.h,),
                Container(
                    margin: EdgeInsets.only(top: 14.h,bottom: 10.h),
                    height: 51.h,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Row(children: [
                      SizedBox(width: 10.w,),
                      Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 30.w,width: 30.w,),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: TextField(
                            controller: selectWalletCont,
                            readOnly: true,
                            onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                            autofocus: true,
                            style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                            decoration:   InputDecoration.collapsed(
                              hintText: 'Select Receiving Wallet',
                              hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                  color: kGrey1
                              ),)),
                      ),
                      GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                                enableDrag: false,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                ),
                                context: context,
                                builder: (context){
                                  List<Wallet> wallets = context.watch<WalletDetails>().wallets;
                                  return Container(
                                    child: ListView.builder(
                                      itemCount:wallets.length ,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return RadioListTile<int>(
                                            activeColor: kYellow,
                                            secondary: Text('₦ ${wallets.elementAt(index).currentBalance!}',
                                              style: TextStyle(fontSize: 20.sp,color: Colors.black),),
                                            title: Text(wallets.elementAt(index).walletName!,
                                              style: TextStyle(fontSize: 20.sp,color: Colors.black),),
                                            subtitle: Text(wallets.elementAt(index).walletNum!),
                                            value: index, groupValue: selectedWallet, onChanged: (val){
                                          setState(() {
                                            selectedWallet = index;
                                            selectWalletCont.text = wallets.elementAt(index).walletName!;
                                            Navigator.pop(context);
                                            toWallet =  wallets.elementAt(index).walletNum!;
                                          });
                                        });
                                      },
                                    ),
                                  );
                                });
                          },
                          child: Icon(Icons.keyboard_arrow_down_sharp))
                      // DropdownButton<Wallet>(
                      //   underline: SizedBox(),
                      //     icon: Icon(Icons.keyboard_arrow_down_sharp),
                      //     items: walletDD,
                      //     onChanged: ( Wallet? val){
                      //      setState(() {
                      //        selectWalletCont.text = val!.walletName!;
                      //        walletNumber = val.walletNum;
                      //      });
                      // })
                      // Icon(Icons.keyboard_arrow_down_sharp)
                    ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.h),
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
                        Expanded(
                          child: TextField(
                            maxLines:1 ,
                            cursorHeight: 0,
                            cursorWidth: 0,
                            controller: contactSearchCont,
                            autofocus: true,
                            onChanged: (val)async{
                               if(val.length == 11){
                              var res = val.split(' ').join();
                              newRes = '234${res.substring(1)}';
                              checkContact();
                              }
                              },
                            keyboardType:TextInputType.number,
                            style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Enter sender\'s phone',
                                hintStyle:  TextStyle(fontSize: 18.sp,
                                    color: kBlack1
                                )),),
                        ),
                        GestureDetector(
                          child: Icon(Icons.contact_phone),
                          onTap: ()async{
                            PhoneContact pCont;
                            print('contact loading');
                            if(FlutterContactPicker.hasPermission() == true){
                              pCont = await FlutterContactPicker.pickPhoneContact();
                              String? num = pCont.phoneNumber?.number;
                              contactSearchCont.text = num!;
                              if(num.length == 17){
                                var res = num.split(' ').join();
                                newRes = res.substring(1);
                              }
                              else if(num.length == 13){
                                var res = num.split(' ').join();
                                newRes = '234${res.substring(1)}';
                              }
                              checkContact();
                            }
                            else{
                              await FlutterContactPicker.requestPermission();
                              pCont = await FlutterContactPicker.pickPhoneContact();
                              String? num = pCont.phoneNumber?.number;
                              contactSearchCont.text = num!;

                              if(num.length == 17){
                                var res = num.split(' ').join();
                                 newRes = res.substring(1);
                              }
                              else if(num.length == 13){
                                var res = num.split(' ').join();
                                newRes = '234${res.substring(1)}';
                              }
                              checkContact();
                            }


                          },
                        )
                      ],
                    )
                ),
                SizedBox(height: 25.h,),
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
                        Expanded(
                          child: TextField(
                            maxLines:1 ,
                            cursorHeight: 0,
                            cursorWidth: 0,
                            autofocus: true,
                            onChanged: (val)async{
                              if(val.length >= 10){
                                spinner(context);
                                wallet = val;
                                final res = await walletLookup(val);
                                Navigator.pop(context);
                                if(res['statusCode'] == 200){
                                  String walletName = res['accountName'];
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
                                                  Text(walletName??'', style: TextStyle(fontWeight: FontWeight.w600))
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
                              else{
                                showSnackBar(context, 'Please check Vault ID.');
                              }
                            },
                            controller: senderVaultIdController,
                            keyboardType:TextInputType.number,
                            style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Sender\'s Vault ID',
                                hintStyle:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,
                                    color: kBlack1
                                )),),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 25.h,),
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
                            cursorHeight: 0,showCursor: true,
                            cursorWidth: 0,
                            cursorColor: kBlue,
                            autofocus: true,
                            inputFormatters: [ThousandsFormatter(allowFraction: true)],
                            onChanged: (val){
                              if(requestFundsAmountCont.text == ''){
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
                            controller: requestFundsAmountCont,
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
                SizedBox(height: 25.h,),
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue),
                    onPressed: () async {
                      if(senderVaultIdController.text == toWallet){
                        showToast('Source and Destination cannot be same');
                        return;
                      }

                      else{
                      spinner(context);
                     final res = await requestFunds(senderVaultIdController.text, toWallet!, requestFundsAmountCont.text);
                     if(res['statusCode'] == 200){
                       showToast('Fund Request sent');
                     }

                      if(res['statusCode'] == 201){
                        showToast(res['errorMessage']);
                      }
                     Navigator.pop(context);
                    }},
                    child: Text('Request Fund',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                  ),
                ),
                SizedBox(height: 10.h,),
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kYellow),
                    onPressed: (toWallet == null || requestFundsAmountCont.text == ''  )?null:()=>genQr(context),
                    child: Text('Generate QRCode',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
        ],),
    ));
  }
  void genQr(BuildContext context)async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
    showModalBottomSheet(
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
        ),
        context: context, builder: (context){
      String accountDetails = jsonEncode({
        "vault":toWallet!,
        "wynkid":prefs.getString('Origwynkid')!,
        "amount":requestFundsAmountCont.text
      });
      print(accountDetails);
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: 200.w,
          height: 350.h,
          child: Column(
            children: [
              Screenshot(
                controller: qrShot ,
                child:
                Container(
                  color: Colors.white,
                  child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: accountDetails,
                  ),
                )

              ),
              SizedBox(height: 20.h,),
              Text('Share link',style: kBoldBlack,),
              SizedBox(height: 20.h,),
              SizedBox(
                width:40,
                height: 40,
                child: GestureDetector(
                    onTap: ()async{
                      spinner(context);
                      final qrPic = await qrShot.capture();
                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/qr.png';
                      File(path).writeAsBytesSync(qrPic!);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var url = await AppUtils.buildDynamicLink(
                          toWallet!,
                          prefs.getString('Origwynkid')!,
                          requestFundsAmountCont.text
                      );
                      String msg = 'Hi, ${context.read<FirstData>().username} has requested that you send him/her a sum of ₦ ${requestFundsAmountCont.text}. Click the link below or scan the QR Code with Wynk App to send it. $url';
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Share.shareXFiles([XFile(path)],text: msg);
                     // launchUrl(Uri.parse('whatsapp://send?phone=+2348145568887&text=$msg'));
                    },
                    child: Icon(Icons.share,color: kYellow,size: 35.sp,)
                ),
              ),
            ],
          )
      );
    });
  }
}


