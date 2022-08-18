import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/payments/airtime_topup.dart';
import 'package:untitled/features/payments/payment_list.dart';
import 'package:untitled/features/payments/send_funds/data_topup.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/constants/textstyles.dart';

import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import 'airtime_payment_gateway.dart';
class DSTV extends StatefulWidget {
  const DSTV({Key? key}) : super(key: key);

  @override
  _DSTVState createState() => _DSTVState();
}



class _DSTVState extends State<DSTV> {

  TvCard? selectedCard;
  String? pin;
  String? productCode;
  @override
  void deactivate() {
    context.read<FirstData>().fromWallet = null;
    smartCardCont.text = '';
    productCode = null;
    selectedCard = null;
    selectBouquetCont.text = '';
    selectWalletCont.text= '';
    // TODO: implement deactivate
    super.deactivate();
  }
  bool pay = false;
  @override
  Widget build(BuildContext context) {

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
                Text('DSTV\nSubscription',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 10.h,),
                WalletCont(),
                SizedBox(height: 10.h,),
                Container(
                    margin: EdgeInsets.only(top: 10.h,bottom: 12.h),
                    height: 51.h,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Row(children: [
                      SizedBox(width: 10.w,),
                      Image.asset('lib/assets/images/dstv.png',height: 30.w,width: 30.w,),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: TextField(
                            controller: selectBouquetCont,
                            readOnly: true,
                            onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                            autofocus: true,
                            style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                            decoration:   InputDecoration.collapsed(
                              hintText: 'Select Bouquet',
                              hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: kGrey1),)),
                      ),
                      GestureDetector(
                          onTap: ()async{
                            spinner(context);
                            List <TvCard> cards = [];
                            final res = await multiChoiceLookup('DSTV');
                            final response = res['message'] as List;
                            response.forEach((element) {
                              cards.add(TvCard.fromJson(element));
                            });
                            Navigator.pop(context);
                            showModalBottomSheet(
                                enableDrag: false,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                ),
                                context: context,
                                builder: (context){

                                  return Container(
                                    child: ListView.builder(
                                      itemCount:cards.length ,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: (){
                                           selectedCard = cards[index];
                                           selectBouquetCont.text = selectedCard!.name;
                                           Navigator.pop(context);
                                           setState(() {

                                           });
                                          },
                                          title: Text(cards[index].name,style: kBoldBlack,),
                                        );
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
                            controller: smartCardCont,
                            autofocus: true,
                            onChanged: (val)async{
                                if(val.length == 10){
                                  spinner(context);
                                  final res = await multichoiceValidate('DSTV', smartCardCont.text);
                                  productCode = res['productCode'];
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
                                                  Text('Name',style: TextStyle(fontSize: 15.sp),),
                                                  Text(res['customer_name'],style: TextStyle(fontWeight: FontWeight.w600))
                                                ],),
                                              SizedBox(height:10.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(child: Text('Customer No.',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 15.sp),)),
                                                  SizedBox(width: 10.w),
                                                  Text(res['customerNumber']!??'', style: TextStyle(fontWeight: FontWeight.w600))
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
                                                    Navigator.pop(context);
                                                    if(selectedCard != null || productCode != null || context.read<FirstData>().fromWallet != null) {
                                                      setState(() {
                                                        pay = true;
                                                      });
                                                    }
                                                    else{
                                                      showSnackBar(context, 'One or more fields left empty');
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
                                }
                            },
                            keyboardType:TextInputType.number,
                            style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Enter Smart Card Code',
                                hintStyle:  TextStyle(fontSize: 18.sp,
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
                                            pay = false;
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                PaymentGateway(
                                                  future: multichoicePurchase(
                                                      selectedCard!.code,
                                                      selectedCard!.amount,
                                                      productCode!,
                                                      context.read<FirstData>().fromWallet!),
                                                  function: (){
                                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                        DSTV()));
                                                  },
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
                      child: Text('Next',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
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

