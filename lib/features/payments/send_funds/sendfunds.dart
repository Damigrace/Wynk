
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers.dart';
import '../../../main.dart';
import '../../../services.dart';
import '../../../utilities/constants/colors.dart';
import '../../../utilities/constants/textstyles.dart';
import '../../../utilities/widgets.dart';
import '../../wynk-pass/pass_purchase_success.dart';
import '../airtime_payment_gateway.dart';
import '../payment_list.dart';

class SendFunds1 extends StatefulWidget {
  const SendFunds1({Key? key}) : super(key: key);

  @override
  State<SendFunds1> createState() => _SendFunds1State();
}

class _SendFunds1State extends State<SendFunds1>{
  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}

  String? pin;
  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    selectWalletCont.text = 'Select Wallet';
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement deactivate
    sendFundsAmountCont.clear();
    sendFundsVaultNumCont.clear();
    sendFundsWynkid.clear();
    sendFundsNarrationCont.clear();
    fromWallet = '';
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int? selectedWallet;
  //List<Wallet> walletList = [];
  String? walletName;
  String? fromWallet;
  @override
  Widget build(BuildContext context) {
    // List<Wallet> wallets = context.watch<WalletDetails>().wallets;
    // for(var wallet in wallets){
    //  //walletList.add(wallet);
    //  var val = DropdownMenuItem<Wallet>(
    //    child: Text(wallet.walletName!),
    //    value: wallet,
    //  );
    //  walletDD.add(val);
    // }

    return Scaffold(
      
      key: _key,
      drawer:  Drawer(elevation: 0,
        backgroundColor: Colors.white,
        width: 250.w,
        child: DrawerWidget(),
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: 18.w,right: 18.w,top: 59.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 88.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 26.r,
                          backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),
                          child:Container(),
                        ),
                        Text(context.watch<FirstData>().userType == '2'?'Capt. ${
                            context.watch<FirstData>().user}'
                            :context.watch<FirstData>().user!,style: TextStyle(fontSize: 20.sp))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap:  () { _key.currentState!.openDrawer();},
                    child: Image.asset('lib/assets/menu.webp'),
                  ),],),
              SizedBox(height: 20.h,),
              Text('Send Funds',style: TextStyle(fontSize: 30.sp),),
              SizedBox(height: 25.h,),
              Container(
                  margin: EdgeInsets.only(top: 14.h,bottom: 27.h),
                  height: 61.h,
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
                              hintText: 'Select Wallet',
                              hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                  color: Colors.black
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
                                          fromWallet =  wallets.elementAt(index).walletNum!;
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
              SizedBox(height: 15.h,),
              Container(
                  height: 61.h,
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
                            showDialog(
                                barrierDismissible: false,
                                context: context, builder: (context){
                              return Container(child:
                              SpinKitCircle(
                                color: kYellow,
                              ),);});

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
              SizedBox(height: 15.h,),
              Container(
                  height: 61.h,
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
                            hintText:  'Beneficiary Wynkid',
                            hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                color: kGrey1
                            )),
                        controller: sendFundsWynkid,),
                    )
                  ],
                  )
              ),
              SizedBox(height: 15.h,),
              Container(
                  height: 61.h,
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
                        keyboardType: TextInputType.number,
                        style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                        decoration:   InputDecoration.collapsed(
                            hintText:  'Enter Amount',
                            hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                color: kGrey1
                            )),
                        controller: sendFundsAmountCont,),
                    )
                  ],
                  )
              ),
              SizedBox(height: 15.h,),
              Container(
                  height: 61.h,
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
                            hintText:  'Narration (Optional)',
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
                                    onPressed: ()  async {
                                      transactionPinController.clear();
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context, builder: (context){
                                        return Container(child:
                                        SpinKitCircle(
                                          color: kYellow,
                                        ),);});
                                      Map loginResponse = await sendLoginDetails(pin: pin!);
                                      inputVaultPin.clear();
                                      if(loginResponse['statusCode'] != 200){
                                        Navigator.pop(context);
                                        showToast('Incorrect Transaction Pin');
                                      }
                                      else{
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentGateway(
                                                      future: wallet2wallet(fromWallet, sendFundsVaultNumCont.text,
                                                          sendFundsAmountCont.text),
                                                      function: (){
                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                            SendFunds1()));
                                                      }, amount:  sendFundsAmountCont.text, purpose: 'funds transfer',
                                                    )));

                                        //print('$fromWallet, ${sendFundsVaultNumCont.text}, ${sendFundsAmountCont.text}');

                                       // final res = await wallet2wallet(fromWallet, sendFundsVaultNumCont.text, sendFundsAmountCont.text);
                                       // Navigator.pop(context);
                                       // Navigator.pop(context);

                                        // final passPaymentStat = await payForPass(passId: context.read<PassSubDetails>().passId!);
                                        // if(passPaymentStat['statusCode'] == 200){
                                        //   showToast(passPaymentStat['errorMessage']);
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchaseConfirm()));
                                        // }
                                        // else{
                                        //   Navigator.pop(context);
                                        //   showToast(passPaymentStat['errorMessage']);
                                        // }
                                      }                                    },
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
            ],),
        ),
      ) ,);
  }
}