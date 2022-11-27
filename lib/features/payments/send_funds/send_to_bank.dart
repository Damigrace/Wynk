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
class SendToBank extends StatefulWidget {
  const SendToBank({Key? key}) : super(key: key);

  @override
  _SendToBankState createState() => _SendToBankState();
}

class _SendToBankState extends State<SendToBank> {
  int? selectedWallet;
  String? fromWallet;
  String? accountName;
  String? accountNum;
  String pin = '';
  String? bankCode;
  String? accType;
  Color? color = kGrey1;
  bool nairaIsVisible = false;
  void changeBorder(){
    setState(() {
      Future.delayed(Duration(milliseconds: 100));
    });
  }
  @override
  Widget build(BuildContext context) {
    print('thi');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WalletCont(),
        SizedBox(height: 10.h,),
        Container(
            height: 51.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: color!),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(
                  onTap: () async {
                    spinner(context);
                    final res = await commBanks();
                    if(res['statusCode'] == 200){
                      List bnk = res['message'] as List;
                      List<BanksModel> list = [];
                      for(var bank in bnk ){
                        BanksModel banksModel = BanksModel(bankName:bank['bankName'],bankCode: bank['bankCode'] );
                        list.add(banksModel);}
                      List<BanksModel> searchList = list;
                      void searchBank(String query){
                        final suggestions = list.where((bank){
                          final bankName = bank.bankName!.toLowerCase();
                          final input = query.toLowerCase();
                          return bankName.contains(input);
                        }).toList();
                        setState(() {
                          searchList = suggestions;
                        });
                      }
                      Navigator.pop(context);
                      showModalBottomSheet(
                          enableDrag: false,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                          ),
                          context: context,
                          builder: (context){
                            return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                        Icon(Icons.search),
                                        SizedBox(width: 10.w,),
                                        Expanded(
                                          child: TextField(
                                            onChanged: (val){
                                              setState(() {});
                                              searchBank(val);

                                            },
                                            autofocus: true,
                                            keyboardType: TextInputType.text,
                                            style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                                color: Colors.black
                                            ),
                                            decoration:   InputDecoration.collapsed(
                                                hintText:  'Search bank',
                                                hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                                    color: kGrey1
                                                )),),

                                        )
                                      ],
                                      )
                                  ),
                                  Expanded(child:   ListView.separated(
                                    itemCount:searchList.length ,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        onTap: (){
                                          color = kGrey1;
                                          selectBankCont.text = searchList.elementAt(index).bankName!;
                                          bankCode = searchList.elementAt(index).bankCode!;
                                          accType = 'bank';
                                          // accType='bank';
                                          // bankCode=list.elementAt(index)['bankCode'];

                                          Navigator.pop(context);
                                          changeBorder();
                                        },
                                        leading: Icon(Icons.food_bank),
                                        title: Text( searchList.elementAt(index).bankName!,style: TextStyle(fontWeight: FontWeight.w600)),

                                      );
                                    }, separatorBuilder: (BuildContext context, int index) { return Divider(); },
                                  ))

                                ],);
                            },);
                          });
                    }
                    else{
                      Navigator.pop(context);
                      showSnackBar(context, res['errorMessage']);
                    }
                  },

                  style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600, color: Colors.black,overflow: TextOverflow.ellipsis),
                  decoration:   InputDecoration.collapsed(
                      hintText:  'Choose Beneficiary\'s Bank',
                      hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                          color: kGrey1
                      )),
                  readOnly: true,
                  controller: selectBankCont,),
              )
            ],
            )
        ),
        SizedBox(height: 10.h,),
      SizedBox(height: 15.h,),
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
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                    color: Colors.black
                ),
                decoration:   InputDecoration.collapsed(
                    hintText:  'Enter 10-digits account number',
                    hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                        color: kGrey1
                    )),
                onChanged: (val)async{
                  if(val.length == 10){
                    if(bankCode == null){
                      showToast('Please select bank');
                      setState(() {
                        color = Colors.red;
                      });
                    }
                    else{
                      color = kGrey1;
                    showDialog(
                        barrierDismissible: false,
                        context: context, builder: (context){
                      return Container(child:
                      SpinKitCircle(
                        color: kYellow,
                      ),);});
                    print('${accNumberCont.text}: $accType: $bankCode');
                    final res = await getAccountDetails(
                        accNumberCont.text,
                      'bank',
                      bankCode!
                    );
                    Navigator.pop(context);
                    FocusScope.of(context).nextFocus();
                    if(res['statusCode'] == 200){
                      accountName = res['accountName'];
                      accountNum = res['accountNumber'];
                      await showDialog(
                          barrierDismissible: false,
                          context: context, builder: (context){
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(10.w),
                          shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)
                          ),
                          content: Container(
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Bank Name',style: TextStyle(fontSize: 15.sp),),
                                      SizedBox(width: 10.w),
                                      Flexible(
                                        child: SizedBox(child: Text(selectBankCont.text,textAlign: TextAlign.end
                                          ,style: TextStyle(fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),maxLines: 2,)),
                                      )
                                    ],),
                                  SizedBox(height:10.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Account Name',style: TextStyle(fontSize: 15.sp),),
                                      SizedBox(width: 10.w),
                                      Flexible(
                                        child: SizedBox(child: Text(accountName??''
                                          ,style: TextStyle(fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis),maxLines: 2,textAlign: TextAlign.end,)),
                                      )
                                    ],),
                                  SizedBox(height:10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(child: Text('Account Number',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 15.sp),)),
                                      SizedBox(width: 10.w),
                                      Flexible(
                                        child: SizedBox(
                                            child: Text(accountNum!,
                                              style: TextStyle(fontWeight: FontWeight.w600,
                                                  overflow: TextOverflow.ellipsis),maxLines: 2,)),
                                      )
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
                }},
                controller: accNumberCont,),
            )
          ],
          )
      ),
        SizedBox(height: 10.h,),
        SizedBox(height: 15.h,),
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
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  cursorColor: kBlue,
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
      SizedBox(height: 20,),
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
                              Map loginResponse = await sendLoginDetails(pin: pin);
                              inputVaultPin.clear();
                              if(loginResponse['statusCode'] != 200){
                                Navigator.pop(context);
                                showToast('Incorrect Transaction Pin');
                              }
                              else{
                                Navigator.pop(context);
                                Navigator.pop(context);
                                print('$accountNum:${context.read<FirstData>().fromWallet}:${sendFundsAmountCont.text}:$bankCode');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentGateway(
                                              details: 'Fund Successfully Sent for processing',
                                              future: wallet2Bank(accountNum, context.read<FirstData>().fromWallet,
                                                  sendFundsAmountCont.text,accountName!, bankCode!),
                                              function: (){
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                    SendCash()));
                                              }, amount: sendFundsAmountCont.text, purpose: 'funds transfer',
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
          child: Text('Next',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
        ),
      ),
      // Container(
      //     margin: EdgeInsets.only(top: 14.h,bottom: 27.h),
      //     height: 61.h,
      //     width: double.infinity,
      //     decoration:  BoxDecoration(
      //         borderRadius: BorderRadius.circular(7),
      //         border: Border.all(
      //             color: kGrey1),
      //         color: kWhite),
      //     child:Row(children: [
      //       SizedBox(width: 10.w,),
      //       Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 30.w,width: 30.w,),
      //       SizedBox(width: 10.w,),
      //       Expanded(
      //         child: TextField(
      //             controller: selectWalletCont,
      //             readOnly: true,
      //             onEditingComplete:()=> FocusScope.of(context).nextFocus(),
      //             autofocus: true,
      //             style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //                 color: Colors.black
      //             ),
      //             decoration:   InputDecoration.collapsed(
      //               hintText: 'Select Wallet',
      //               hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //                   color: Colors.black
      //               ),)),
      //       ),
      //       GestureDetector(
      //           onTap: (){
      //             showModalBottomSheet(
      //                 enableDrag: false,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
      //                 ),
      //                 context: context,
      //                 builder: (context){
      //                   List<Wallet> wallets = context.watch<WalletDetails>().wallets;
      //                   return Container(
      //                     child: ListView.builder(
      //                       itemCount:wallets.length ,
      //                       shrinkWrap: true,
      //                       itemBuilder: (BuildContext context, int index) {
      //                         return RadioListTile<int>(
      //                             activeColor: kYellow,
      //                             secondary: Text('₦ ${wallets.elementAt(index).currentBalance!}',
      //                               style: TextStyle(fontSize: 20.sp,color: Colors.black),),
      //                             title: Text(wallets.elementAt(index).walletName!,
      //                               style: TextStyle(fontSize: 20.sp,color: Colors.black),),
      //                             subtitle: Text(wallets.elementAt(index).walletNum!),
      //                             value: index, groupValue: selectedWallet, onChanged: (val){
      //                           setState(() {
      //                             selectedWallet = index;
      //                             selectWalletCont.text = wallets.elementAt(index).walletName!;
      //                             Navigator.pop(context);
      //                             fromWallet =  wallets.elementAt(index).walletNum!;
      //                           });
      //                         });
      //                       },
      //                     ),
      //                   );
      //                 });
      //           },
      //           child: Icon(Icons.keyboard_arrow_down_sharp))
      //       // DropdownButton<Wallet>(
      //       //   underline: SizedBox(),
      //       //     icon: Icon(Icons.keyboard_arrow_down_sharp),
      //       //     items: walletDD,
      //       //     onChanged: ( Wallet? val){
      //       //      setState(() {
      //       //        selectWalletCont.text = val!.walletName!;
      //       //        walletNumber = val.walletNum;
      //       //      });
      //       // })
      //       // Icon(Icons.keyboard_arrow_down_sharp)
      //     ],
      //     )
      // ),
      // SizedBox(height: 15.h,),
      // Container(
      //     height: 61.h,
      //     width: double.infinity,
      //     decoration:  BoxDecoration(
      //         borderRadius: BorderRadius.circular(7),
      //         border: Border.all(
      //             color: kGrey1),
      //         color: kWhite),
      //     child:Row(children: [
      //       SizedBox(width: 18.w,),
      //       Expanded(
      //         child: TextField(
      //           onEditingComplete:()=> FocusScope.of(context).nextFocus(),
      //           onChanged: (val)async{
      //             if(val.length == 10){
      //               showDialog(
      //                   barrierDismissible: false,
      //                   context: context, builder: (context){
      //                 return Container(child:
      //                 SpinKitCircle(
      //                   color: kYellow,
      //                 ),);});
      //
      //               final res = await walletLookup(val);
      //               Navigator.pop(context);
      //               if(res['statusCode'] == 200){
      //                 walletName = res['accountName'];
      //                 await showDialog(
      //                     barrierDismissible: false,
      //                     context: context, builder: (context){
      //                   return AlertDialog(
      //                     contentPadding: EdgeInsets.all(10.w),
      //                     shape:  RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(18)
      //                     ),
      //                     content: Container(
      //                       width: 301.w,
      //                       height:270.h,
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         mainAxisSize: MainAxisSize.min,
      //                         children: [
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text('Confirm Information',
      //                                 style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
      //                               SizedBox(height: 13.h,),
      //                               Text('Please review the information below before proceeding',
      //                                   overflow: TextOverflow.ellipsis,
      //                                   maxLines: 2,
      //                                   style: TextStyle(fontSize: 12.sp,color: kYellow)),
      //                               SizedBox(height: 30.h,),
      //                             ],),
      //                           Column(children: [
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 Text('Vault ID',style: TextStyle(fontSize: 15.sp),),
      //                                 Text(val,style: TextStyle(fontWeight: FontWeight.w600))
      //                               ],),
      //                             SizedBox(height:10.h),
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 SizedBox(child: Text('Vault name',
      //                                   overflow: TextOverflow.ellipsis,
      //                                   style: TextStyle(fontSize: 15.sp),)),
      //                                 SizedBox(width: 10.w),
      //                                 Text(walletName!??'', style: TextStyle(fontWeight: FontWeight.w600))
      //                               ],)
      //                           ],),
      //                           SizedBox(height:47.h),
      //                           Align(
      //                             alignment: Alignment.center,
      //                             child: Container(
      //                               height: 50.h,
      //                               width: 241.w,
      //                               child: ElevatedButton(
      //                                 style: ElevatedButton.styleFrom(
      //                                     backgroundColor: kBlue),
      //                                 onPressed: ()  async {
      //                                   sendFundsWynkid.text = res['wynkid'];
      //                                   Navigator.pop(context);
      //                                 },
      //                                 child: Text('Confirm',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
      //                               ),
      //                             ),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 });
      //               }
      //               else{
      //                 showToast('We could not fetch beneficiary details');
      //               }
      //             }
      //           },
      //           autofocus: true,
      //           keyboardType: TextInputType.number,
      //           style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //               color: Colors.black
      //           ),
      //           decoration:   InputDecoration.collapsed(
      //               hintText:  'Enter beneficiary\'s vault number',
      //               hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //                   color: kGrey1
      //               )),
      //           controller: sendFundsVaultNumCont,),
      //       )
      //     ],
      //     )
      // ),
      // SizedBox(height: 15.h,),
      // Container(
      //     height: 61.h,
      //     width: double.infinity,
      //     decoration:  BoxDecoration(
      //         borderRadius: BorderRadius.circular(7),
      //         border: Border.all(
      //             color: kGrey1),
      //         color: kWhite),
      //     child:Row(children: [
      //       SizedBox(width: 18.w,),
      //       Expanded(
      //         child: TextField(
      //           autofocus: true,
      //           readOnly: true,
      //           keyboardType: TextInputType.number,
      //           style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //               color: Colors.black
      //           ),
      //           decoration:   InputDecoration.collapsed(
      //               hintText:  'Beneficiary Wynkid',
      //               hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //                   color: kGrey1
      //               )),
      //           controller: sendFundsWynkid,),
      //       )
      //     ],
      //     )
      // ),
      // SizedBox(height: 15.h,),
      // Container(
      //     height: 61.h,
      //     width: double.infinity,
      //     decoration:  BoxDecoration(
      //         borderRadius: BorderRadius.circular(7),
      //         border: Border.all(
      //             color: kGrey1),
      //         color: kWhite),
      //     child:Row(children: [
      //       SizedBox(width: 18.w,),
      //       Expanded(
      //         child: TextField(
      //           onEditingComplete:()=> FocusScope.of(context).nextFocus(),
      //           autofocus: true,
      //           keyboardType: TextInputType.number,
      //           style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //               color: Colors.black
      //           ),
      //           decoration:   InputDecoration.collapsed(
      //               hintText:  'Enter Amount',
      //               hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //                   color: kGrey1
      //               )),
      //           controller: sendFundsAmountCont,),
      //       )
      //     ],
      //     )
      // ),
      // SizedBox(height: 15.h,),
      // Container(
      //     height: 61.h,
      //     width: double.infinity,
      //     decoration:  BoxDecoration(
      //         borderRadius: BorderRadius.circular(7),
      //         border: Border.all(
      //             color: kGrey1),
      //         color: kWhite),
      //     child:Row(children: [
      //       SizedBox(width: 18.w,),
      //       Expanded(
      //         child: TextField(
      //           onEditingComplete:()=> FocusScope.of(context).nextFocus(),
      //
      //           autofocus: true,
      //           keyboardType: TextInputType.text,
      //           style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //               color: Colors.black
      //           ),
      //           decoration:   InputDecoration.collapsed(
      //               hintText:  'Narration (Optional)',
      //               hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
      //                   color: kGrey1
      //               )),
      //           controller: sendFundsNarrationCont,),
      //       )
      //     ],
      //     )
      // ),
      // SizedBox(height: 20.h,),
      // SizedBox(
      //   height: 50.h,
      //   width: double.infinity,
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //         backgroundColor: kBlue),
      //     onPressed: () async {
      //       await showDialog(
      //           barrierDismissible: false,
      //           context: context, builder: (context){
      //         return AlertDialog(
      //           contentPadding: EdgeInsets.all(30.w),
      //           shape:  RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(18)
      //           ),
      //           content: Container(
      //             width: 301.w,
      //             height:270.h,
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text('Enter PIN',
      //                           style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
      //                         SizedBox(height: 13.h,),
      //                         Text('Enter your 4-digit PIN to authorise \nthis transaction.',
      //                             style: TextStyle(fontSize: 10.sp)),
      //                       ],),
      //                     GestureDetector(
      //                       onTap: ()=>Navigator.pop(context),
      //                       child: SizedBox(
      //                           width: 42.w,
      //                           height: 42.w,
      //                           child: Image.asset('lib/assets/images/rides/cancel1.png')),
      //                     )
      //                   ],),
      //
      //                 Align(
      //                   alignment: Alignment.center,
      //                   child: Container(
      //                     margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
      //                     height: 61.h,
      //                     width: 260.w,
      //                     decoration:  BoxDecoration(
      //                       borderRadius: BorderRadius.circular(7),),
      //                     child: PinCodeTextField(
      //                       showCursor: true,
      //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                       autoUnfocus: true,
      //                       autoDisposeControllers: false,
      //                       keyboardType: TextInputType.number,
      //                       onChanged: (v){},
      //                       autoFocus: true,
      //                       length: 4,
      //                       obscureText: true,
      //                       animationType: AnimationType.fade,
      //                       pinTheme: PinTheme(
      //                         activeFillColor: kWhite,
      //                         inactiveFillColor: kWhite,
      //                         selectedFillColor: kWhite,
      //                         activeColor: kGrey1,
      //                         inactiveColor: kGrey1,
      //                         selectedColor: kGrey1,
      //                         shape: PinCodeFieldShape.box,
      //                         borderRadius: BorderRadius.circular(5),
      //                         fieldHeight: 61.h,
      //                         fieldWidth: 51.w,
      //                       ),
      //                       animationDuration: Duration(milliseconds: 300),
      //                       controller: transactionPinController,
      //                       onCompleted: (v) async{
      //                         pin=v;
      //                       },
      //                       beforeTextPaste: (text) {
      //                         print("Allowing to paste $text");
      //                         //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
      //                         //but you can show anything you want here, like your pop up saying wrong paste format or etc
      //                         return true;
      //                       }, appContext: context,
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(height:47.h),
      //                 Align(
      //                   alignment: Alignment.center,
      //                   child: Container(
      //                     height: 50.h,
      //                     width: 241.w,
      //                     child: ElevatedButton(
      //                       style: ElevatedButton.styleFrom(
      //                           backgroundColor: kBlue),
      //                       onPressed: ()  async {
      //                         transactionPinController.clear();
      //                         showDialog(
      //                             barrierDismissible: false,
      //                             context: context, builder: (context){
      //                           return Container(child:
      //                           SpinKitCircle(
      //                             color: kYellow,
      //                           ),);});
      //                         Map loginResponse = await sendLoginDetails(pin: pin!);
      //                         inputVaultPin.clear();
      //                         if(loginResponse['statusCode'] != 200){
      //                           Navigator.pop(context);
      //                           showToast('Incorrect Transaction Pin');
      //                         }
      //                         else{
      //                           Navigator.pop(context);
      //                           Navigator.pop(context);
      //                           Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       PaymentGateway(
      //                                         future: wallet2wallet(fromWallet, sendFundsVaultNumCont.text, sendFundsAmountCont.text),
      //                                         function: (){
      //                                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
      //                                               SendFunds1()));
      //                                         },
      //                                       )));
      //
      //                           //print('$fromWallet, ${sendFundsVaultNumCont.text}, ${sendFundsAmountCont.text}');
      //
      //                           // final res = await wallet2wallet(fromWallet, sendFundsVaultNumCont.text, sendFundsAmountCont.text);
      //                           // Navigator.pop(context);
      //                           // Navigator.pop(context);
      //
      //                           // final passPaymentStat = await payForPass(passId: context.read<PassSubDetails>().passId!);
      //                           // if(passPaymentStat['statusCode'] == 200){
      //                           //   showToast(passPaymentStat['errorMessage']);
      //                           //   Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchaseConfirm()));
      //                           // }
      //                           // else{
      //                           //   Navigator.pop(context);
      //                           //   showToast(passPaymentStat['errorMessage']);
      //                           // }
      //                         }                                    },
      //                       child: Text('Confirm',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         );
      //       });
      //     },
      //     child: Text('Transfer',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
      //   ),
      // ),
    ],);
  }
}
