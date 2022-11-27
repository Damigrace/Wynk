import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wynk/features/wynk-pass/wynk_pass_confirmation.dart';

import '../../controllers.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class PrepaidPassConfirmation extends StatefulWidget {
  const PrepaidPassConfirmation({Key? key}) : super(key: key);

  @override
  _PrepaidPassConfirmationState createState() => _PrepaidPassConfirmationState();
}

class _PrepaidPassConfirmationState extends State<PrepaidPassConfirmation> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  num vaultBalance=0;
  int? selectedV;
  bool showBalance = true;
  Icon icon = Icon(CupertinoIcons.eye_slash_fill,size: 20.sp,color: kBlueTint,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 15.w,top: 10.h,right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 91.w,
                      height: 88.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 26.r,
                            backgroundColor: Colors.red,
                            child:Container(),
                          ),
                          Text('Captain',style: TextStyle(fontSize: 20.sp))
                        ],
                      ),
                    ),
                    backButton(context)
                  ],),
              ),
              Container(
                padding: EdgeInsets.only(left: 11.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Vault',style: TextStyle(fontSize: 30.sp),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: icon,onPressed: (){
                                setState(() {
                                  showBalance = !showBalance;
                                  showBalance == true?icon=Icon(CupertinoIcons.eye_slash_fill,size: 20.sp,color: kBlueTint,):
                                  icon=Icon(CupertinoIcons.eye_fill,size: 20.sp,color: kBlueTint,);
                                });
                              }),
                            ),
                            SizedBox(width: 10.w,),
                            Text( 'Account Balance',style:TextStyle(color: Colors.black,fontSize: 18.sp))
                          ],
                        ),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Available Balance:',style: TextStyle(fontSize: 20.sp),),
                        SizedBox(height: 10.h,),
                        Flexible(
                          child: Container(
                            width: 120.w,height:25.h,
                            child: TextField(
                              textAlign: TextAlign.start,
                              style:TextStyle(color: Colors.green,fontSize: 20.sp) ,
                              obscureText: showBalance,
                              obscuringCharacter: '*',
                              decoration: InputDecoration.collapsed(hintText: ''),
                              readOnly: true,
                              controller: accountBalCont,
                            ),
                          ),
                        ),
                      ],),
                    SizedBox(height: 19.h,),
                    Text('Select Account:'),
                    SizedBox(height: 28.h,),
                    Divider(height: 1.5.h,color: Colors.black26,),
                    SizedBox(height: 40.h,),
                    Row(children: [
                      Radio<int>(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        activeColor: kYellow,
                        value: 0,
                        groupValue: selectedV,
                        onChanged: (val){setState(() {
                          selectedV = val;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation()));
                        });},
                      ),
                      SizedBox(width: 16.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('Business',style: TextStyle(color: kBlueTint,fontSize:15.sp ),),
                        SizedBox(height:5.h),
                        Text('Vault No. 3810030779 ',style: TextStyle(color: kBlueTint,fontSize: 15.sp),)
                      ],),
                      Expanded(child: Container(child: Text('₦ 30,000,000',style: TextStyle(color: Colors.green),textAlign: TextAlign.right
                        ,),))
                    ],),
                    SizedBox(height: 29.h,),
                    Row(children: [
                      Radio<int>(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        activeColor: kYellow,
                        value: 1,
                        groupValue: selectedV,
                        onChanged: (val){setState(() {
                          selectedV = val;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation()));
                        });},
                      ),
                      SizedBox(width: 16.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Business',style: TextStyle(color: kBlueTint,fontSize:15.sp ),),
                          SizedBox(height:5.h),
                          Text('Vault No. 3810030779 ',style: TextStyle(color: kBlueTint,fontSize: 15.sp),)
                        ],),
                      Expanded(child: Container(child: Text('₦ 20,000,000',style: TextStyle(color: Colors.green),textAlign: TextAlign.right
                        ,),))
                    ],)
                    // RadioListTile<int>(
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Text('Business',style: TextStyle(color: kBlueTint),),
                    //     subtitle: Row(
                    //       children: [
                    //         Text('',style: TextStyle(color: kBlueTint),),
                    //         SizedBox(
                    //             width: 14.w,
                    //             height: 14.h,
                    //             child: GestureDetector(
                    //                 onTap: (){},
                    //                 child: Icon(Icons.copy,size: 18.sp,color: Colors.black,)))
                    //       ],
                    //     ),
                    //     activeColor: kYellow,
                    //     secondary: Text('₦ 30,000,000',style: TextStyle(color: Colors.green),),
                    //     value: 0,
                    //     groupValue: selectedV,
                    //     onChanged: (val){
                    //       setState(() {
                    //         selectedV = val;
                    //       });
                    //       Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation()));
                    // }),
                    // RadioListTile<int>(
                    //     contentPadding: EdgeInsets.zero,
                    //     title: Text('School Fees',style: TextStyle(color: kBlueTint),),
                    //     secondary: Text('₦ 30,000,000',style: TextStyle(color: Colors.green),),
                    //     subtitle: Row(
                    //       children: [
                    //         Text('Vault No. 3810030779 ',style: TextStyle(color: kBlueTint),),
                    //         SizedBox(
                    //             width: 14.w,
                    //             height: 14.h,
                    //             child: GestureDetector(
                    //                 onTap: (){},
                    //                 child: Icon(Icons.copy,size: 18.sp,color: Colors.black,)))
                    //       ],
                    //     ),
                    //     activeColor: kYellow,
                    //     value: 1,
                    //     groupValue: selectedV,
                    //     onChanged: (val){
                    //       setState(() {
                    //         selectedV = val;
                    //       });
                    //       Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation()));
                    // }),
                  ],),
              ),
            ],),
        ),
      ),
    );
  }
}
