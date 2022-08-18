import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/payments/internet_sub_main.dart';
import 'package:untitled/features/payments/payment_list.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
import 'airtime_payment_gateway.dart';
class SmileSubPage extends StatefulWidget {
  const SmileSubPage({Key? key}) : super(key: key);

  @override
  _SmileSubPageState createState() => _SmileSubPageState();
}

class _SmileSubPageState extends State<SmileSubPage> {
  String? pin;
  bool showSmilePlan = false;
  SmileCard? selectedCard;

  String? pCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 36.w,right:36.w,top: 77.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 31.h,),
                Text('Smile\nSubcriptions',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 37.h,),
                WalletCont(),
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
                            controller: smileAccCont,
                            autofocus: true,
                            onChanged: (val)async{
                              if(val.length == 10){
                                List<SmileCard> smileCards = [];
                                spinner(context);
                                final res = await smileLookup(val);

                                List bundles = res['message'] as List;

                                bundles.forEach((element) {
                                  SmileCard sCard = SmileCard(
                                    name: element['name'], price: element['price'].toString(),
                                    code: element['code'], validity: element['validity'],
                                    displayPrice: element['displayPrice'].toString(),);
                                  smileCards.add(sCard);
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
                                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                                        child: ListView.builder(
                                          itemCount:smileCards.length ,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              children: [
                                                SizedBox(height: 10.h,),
                                                GestureDetector(
                                                  onTap:(){
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      setState(() {
                                                        selectedCard = smileCards[index];
                                                        smilePLan.text = selectedCard!.name;
                                                        showSmilePlan = true;
                                                      });
                                                    });

                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal:10,vertical:8),
                                                    decoration:  BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: kWhite),
                                                    width: double.infinity,
                                                    height: 120.h,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(smileCards[index].name,style: kBoldBlack,),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text('₦ ',style: TextStyle( fontWeight: FontWeight.w600,color: kBlue),),
                                                                Text(smileCards[index].displayPrice,style: kBoldBlue,)
                                                              ],),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Text(smileCards[index].name,style:  TextStyle(color: kGrey1),),
                                                        SizedBox(height: 10.h,),
                                                        Text('-------------------------------------------------------------------------------------------------------------------',
                                                          maxLines: 1,overflow: TextOverflow.clip,style: TextStyle(color: kGrey1),)
                                                      ],),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    });
                              }
                            },
                            keyboardType:TextInputType.number,
                            style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  'Enter Smile Number',
                                hintStyle:  TextStyle(fontSize: 18.sp,
                                    color: kBlack1
                                )),),
                        ),

                      ],
                    )
                ),
                SizedBox(height: 20.h,),
                Visibility(
                  visible: showSmilePlan,
                  child: Container(
                      margin: EdgeInsets.only(top: 10.h,bottom: 20.h),
                      height: 51.h,
                      width: double.infinity,
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: kGrey1),
                          color: kWhite),
                      child:Row(children: [
                        SizedBox(width: 10.w,),
                        Expanded(
                          child: TextField(
                              controller: smilePLan,
                              readOnly: true,
                              style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                  color: Colors.black
                              ),
                              decoration:   InputDecoration.collapsed(
                                hintText: 'Chosen Plan',
                                hintStyle:  kBoldGrey,)),
                        ),
                      ],
                      )
                  ),
                ),
                Text('You will be charged a fee of NGN 120 for \nthis transaction.',style: TextStyle(fontSize: 12.5.sp,color: Colors.red),),
                SizedBox(height: 88.h,),
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue),
                    onPressed: () async {
                      spinner(context);
                      final res = await smileValidate(smileAccCont.text);
                      pCode = res['data']['productCode'];
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
                                      Text(res['data']['customerName'],style: TextStyle(fontWeight: FontWeight.w600))
                                    ],),
                                  SizedBox(height:10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(child: Text('Account',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 15.sp),)),
                                      SizedBox(width: 10.w),
                                      Text(smileAccCont.text??'', style: TextStyle(fontWeight: FontWeight.w600))
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
                                        spinner(context);
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
                                                     onPressed: ()  {
                                                       Navigator.pop(context);
                                                       Navigator.pop(context);
                                                       Navigator.push(
                                                           context,
                                                           MaterialPageRoute(
                                                               builder: (context) =>
                                                                   PaymentGateway(
                                                                     future: smilePurchase(
                                                                         smileAccCont.text, selectedCard!.code,
                                                                         selectedCard!.price, pCode!, context.read<FirstData>().fromWallet!),

                                                                     function: (){
                                                                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                                           InternetSubMain()));
                                                                     },
                                                                   )));
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
                    child: Text('Verify',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],),
    ));
  }
}
