import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
import 'payment_gateway.dart';
import 'mobile_recharge.dart';
class AirtimeTopUp extends StatefulWidget {
  const AirtimeTopUp({Key? key}) : super(key: key);

  @override
  _AirtimeTopUpState createState() => _AirtimeTopUpState();
}

class _AirtimeTopUpState extends State<AirtimeTopUp>  {
  int? selectedWallet;
  String? fromWallet;
  String? pin;
  int? selectedVal;
  Color mtnCol = Colors.white;
  Color gloCol = Colors.white;
  Color airtelCol = Colors.white;
  Color mob9Col = Colors.white;
  String? channel;
  String? newRes;

  void checkContact()async{
    final response = await responseFromPhone(newRes!);
    print(response['wynkid']);
    if(response['wynkid'] == null){
      showToast('It seems this contact is not a Wynk user');
    }
    else{
      walletLookup(response['wallet_number']);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    selectWalletCont.clear();
    airtimeAmountCont.clear();
    contactSearchCont.clear();
    selectedVal = 5;
    super.dispose();
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    selectWalletCont.clear();
    airtimeAmountCont.clear();
    contactSearchCont.clear();
    selectedVal = 5;
    super.deactivate();
  }
  bool nairaIsVisible = false;
  BuildContext? ct;
  @override
  void initState() {
    // TODO: implement initState
    selectedVal = context.read<FirstData>().selectedNetwork;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    switch(selectedVal){
      case 1 :
        {
          mtnCol = kBlue;
          gloCol = Colors.white;
          airtelCol = Colors.white;
          mob9Col = Colors.white;
          channel = 'MTN';
        }
        break;
      case 2 :{
        mtnCol = Colors.white;;
        gloCol = Colors.white;
        airtelCol = Colors.white;
        mob9Col = kBlue;
        channel = '9 Mobile';
      };break;
      case 3 : {
        mtnCol = Colors.white;
        gloCol = kBlue;
        airtelCol = Colors.white;
        mob9Col = Colors.white;
        channel = 'GLO';
      };break;
      case 4 : {
        mtnCol = Colors.white;
        gloCol = Colors.white;
        airtelCol = kBlue;
        mob9Col = Colors.white;
        channel = 'Airtel';
      }
    }
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WalletCont(),
        SizedBox(height: 10.h,),
        SizedBox(
          height: 51.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap:(){
                  setState(() {
                    selectedVal = 1;
                  });
                },
                child: Container(
                  child: Image.asset('lib/assets/images/quick_pay/image-6-1@1x.png'),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: mtnCol,width: 2)
                  ),

                ),
              ),
              SizedBox(width: 4.w,),
              GestureDetector(
                onTap:(){
                  setState(() {
                    selectedVal = 2;
                  });
                },
                child: Container(
                  child:  Image.asset('lib/assets/images/quick_pay/image-9-1@1x.png'),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: mob9Col,width: 2)
                  ),

                ),
              ),
              SizedBox(width: 4.w,),
              GestureDetector(
                onTap:(){
                  setState(() {
                    selectedVal = 3;
                  });
                },
                child: Container(
                  child: Image.asset('lib/assets/images/quick_pay/image-7-1@1x.png'),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: gloCol,width: 2)
                  ),

                ),
              ),
              SizedBox(width: 4.w,),
              GestureDetector(
                onTap:(){
                  setState(() {
                    selectedVal = 4;
                  });
                },
                child: Container(
                  child: Image.asset('lib/assets/images/quick_pay/image-8-1@1x.png'),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: airtelCol,width: 2)
                  ),

                ),
              ),

            ],
          ),
        ),
        SizedBox(height: 10.h,),
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
                        FocusScope.of(context).unfocus();
                        var res = val.split(' ').join();
                        newRes = '234${res.substring(1)}';
                      }
                    },

                    keyboardType:TextInputType.number,
                    style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                    decoration:   InputDecoration.collapsed(
                        hintText:  'Enter Phone',
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
                      if(airtimeAmountCont.text == ''){
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
                    controller: airtimeAmountCont,
                    keyboardType:TextInputType.number,
                    style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                    decoration:   InputDecoration.collapsed(
                        hintText:  'Minimum of ₦‎ 50',
                        hintStyle:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,
                            color: kBlack1
                        )),),
                ),
              ],
            )
        ),
        SizedBox(height: 20.h,),
        Align(

          alignment: Alignment.center,
          child: Container(
            height: 50.h,
            width: 318.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue),
              onPressed:(
                  newRes == null ||
                      channel == null
                          || context.read<FirstData>().fromWallet == ''
                  ||
                   airtimeAmountCont.text == ""
              )?null:
                  () async{
                    context.read<FirstData>().savePayRoute('airtime');
                    context.read<PaymentData>().saveChannel(channel!);
                    context.read<PaymentData>().savePhone(newRes!);
                  paymentConfirm(
                     context,
                     airtimeAmountCont.text,
                    'airtime purchase'
                  );

              },
              child: Text('Next',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
            ),
          ),
        )
      ],);
  }


}
