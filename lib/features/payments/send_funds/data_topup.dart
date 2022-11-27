import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';


import '../../../controllers.dart';
import '../../../main.dart';
import '../../../services.dart';
import '../../../utilities/constants/colors.dart';
import '../../../utilities/constants/textstyles.dart';
import '../../../utilities/widgets.dart';
import '../airtime_payment_gateway.dart';
import '../mobile_recharge.dart';

class DataTopUp extends StatefulWidget {
  const DataTopUp({Key? key}) : super(key: key);

  @override
  _DataTopUpState createState() => _DataTopUpState();
}

class _DataTopUpState extends State<DataTopUp> {
  int? selectedWallet;
  String? fromWallet;
  String? pin;
  int? selectedVal = 0;
  Color mtnCol = Colors.white;
  Color gloCol = Colors.white;
  Color airtelCol = Colors.white;
  Color mob9Col = Colors.white;
  String? channel;

  DataCard? selectedCard;
  String? newRes;
  @override
  void initState() {
    selectedVal = context.read<FirstData>().selectedNetwork;
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    selectWalletCont.clear();
    contactSearchCont.clear();
    dataPlanCont.clear();
    selectedVal = 5;
    super.dispose();
  }
  String? service;
  String? amount;
  String? productCode;
  
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
              Icon(Icons.wifi_sharp,color: kBlue,),
              SizedBox(width: 10.w,),

              Expanded(
                child: TextField(
                    controller: dataPlanCont,
                    readOnly: true,
                    style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    decoration:   InputDecoration.collapsed(
                      hintText: 'Choose Data plan',
                      hintStyle:  kBoldGrey,)),
              ),

              GestureDetector(
                  onTap: ()async{
                    spinner(context);
                    List<DataCard> dataCards = [];
                    final res0 = await dataLookup(channel!);
                    if(res0['statusCode'] == 200){
                      List res =res0['message'];
                      res.forEach((element)=>
                          dataCards.add(DataCard.fromJson(element))
                      );
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
                                itemCount:dataCards.length ,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10.h,),
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.pop(context);
                                          selectedCard = dataCards[index];
                                          dataPlanCont.text = selectedCard!.description;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal:10,vertical:8),
                                          decoration:  BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: kWhite),
                                          width: double.infinity,

                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(dataCards[index].description,style: kBoldBlack,)),
                                                  SizedBox(width: 10),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('₦ ',style: TextStyle( fontWeight: FontWeight.w600,color: kBlue),),
                                                      Text(dataCards[index].amount,style: kBoldBlue,)
                                                    ],),
                                                ],
                                              ),
                                              SizedBox(height: 20.h,),
                                              Text(dataCards[index].type,style:  TextStyle(color: kGrey1),),
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
                    else{
                      showSnackBar(context, res0['errorMessage']);
                    }
                  },
                  child: Icon(Icons.keyboard_arrow_down_sharp))

            ],
            )
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10.h),
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
                        hintText:  'Enter sender\'s phone',
                        hintStyle:  TextStyle(fontSize: 18.sp,
                            color: kBlack1
                        )),),
                ),
                GestureDetector(
                  child: Icon(Icons.contact_phone,color: kBlue,),
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
                    }

                  },
                )
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
                  backgroundColor: kBlue),
              onPressed: (newRes == null || selectedCard == null ||context.read<FirstData>().fromWallet == null)?null
                  :() async{
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
                                  onPressed:() async {
                                    spinner(context);
                                    Map loginResponse = await sendLoginDetails(pin: pin!);
                                    transactionPinController.clear();
                                    if(loginResponse['statusCode'] != 200){
                                      Navigator.pop(context);
                                      showToast('Incorrect Transaction Pin');
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      selectWalletCont.clear();
                                      contactSearchCont.clear();
                                      selectedVal = 5;
                                      dataPlanCont.clear();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                          PaymentGateway(
                                            future: dataPurchase(newRes!, selectedCard!.serviceName,
                                                selectedCard!.productCode, context.read<FirstData>().fromWallet!, selectedCard!.code),
                                            function: (){
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                  MobileRecharge()));
                                            }, amount: selectedCard!.amount, purpose: 'data subscription',
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
              child: Text('Next',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
            ),
          ),
        )
      ],);
  }
}
