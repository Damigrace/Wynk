import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/features/wynk-pass/pass_purchase.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
import '../../services.dart';
class PassConfirmation extends StatefulWidget {
  const PassConfirmation({Key? key}) : super(key: key);

  @override
  _PassConfirmationState createState() => _PassConfirmationState();
}

class _PassConfirmationState extends State<PassConfirmation> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  num vaultBalance=0;
  int? selectedV;
  bool showBalance = true;
  Icon icon = Icon(CupertinoIcons.eye_slash_fill,size: 20.sp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 15.w,top: 10.h,right: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
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
                                :context.watch<FirstData>().user??'',style: TextStyle(fontSize: 20.sp)),
                          ],
                        ),
                      ),
                      backButton(context)
                    ],),
                ),
                SizedBox(height: 15.h,),
               WalletCont(),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Amount',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600),),
                    Row(
                      children: [
                        Text('₦ ',style: TextStyle(fontSize: 17.sp,fontWeight: FontWeight.w600),),
                        Text(context.watch<PassSubDetails>().passAmount??'',style: TextStyle(fontSize: 17.sp,fontWeight: FontWeight.w600),),
                      ],
                    ),
                ],),
                Container(
                    padding: EdgeInsets.only(top: 29.h,left: 14.w,right: 14.w),
                    margin: EdgeInsets.only(top: 14.h),
                    width: 365.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(5),
                        border: Border.all(color: kGrey1,)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Accounts', style: TextStyle(fontSize:22.sp ),),
                            TextButton(onPressed: ()async{
                              bool showSB = true;
                              spinner(context);
                              context.read<WalletDetails>().wallets.clear();
                              final res = await walletDetails(context);
                              final wallets = res['message']as List;
                              for(var wallet in wallets){
                                if(wallet['actualBalance'] == '' && showSB == true ){
                                  showSB = false;
                                  showSnackBar(context, 'We could not retrieve your wallet details at this time. Please bear with us.');
                                }
                                Wallet wal = Wallet(walletName: wallet['walletname'],
                                    walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
                                context.read<WalletDetails>().saveWallet(wal);
                              }
                              Navigator.pop(context);
                            }, child: Text('Refresh',style: TextStyle(color: kBlue,fontSize: 18.sp),))
                          ],),
                        Column(children: context.watch<WalletDetails>().wallets)
                      ],)
                ),
                SizedBox(height: 10.h,),
                Text.rich(

                    TextSpan(

                        style: TextStyle(fontSize: 14.sp,height: 1.3.h),
                        text: 'You are about to purchase Wynk\'s  ${context.watch<PassSubDetails>().subType}Captain Pass',
                        children: [
                          WidgetSpan(child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Accept Wynk\'s ', style: TextStyle(fontSize: 14.sp),),
                              GestureDetector(
                                child: Text('Terms & Conditions',style: TextStyle(color: kYellow,fontSize: 14.sp,),),
                                onTap: (){},),
                            ],
                          )
                          )
                        ]
                    ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 9.h,bottom: 33.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(

                        activeColor: kYellow,
                        toggleable: true,
                        onChanged: (value) {
                          setState(() {
                            if(selectedV==0){
                              selectedV=1;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchasePin()));
                            }else{selectedV=0;}
                          });
                        }, groupValue: selectedV, value: 1,

                      ),
                      SizedBox(width: 5.w,),
                      Text('Agree & Continue',style: TextStyle(fontSize: 15.sp),)
                    ],),
                )
            ],),
          ),
        ),
      ),
    );
  }
}
