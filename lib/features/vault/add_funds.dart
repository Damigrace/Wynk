import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
import 'add_funds2.dart';
class AddFunds extends StatelessWidget {
   AddFunds({Key? key}) : super(key: key);
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  num vB = 0;
  @override
  Widget build(BuildContext context) {
    vaultBalanceController.text = '₦${balanceFormatter.format(vB)}';
    return Scaffold(body: Container(
      padding: EdgeInsets.symmetric(horizontal: 27.w,vertical: 41.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        backButton(context),
        SizedBox(height: 66.h,),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 30.sp),
              text: 'Welcome to your ',
            children: [
              TextSpan(text: 'WynkVault!',style: TextStyle(color: kBlue),)
            ]
          ),
        ),
          SizedBox(height: 95.h,),
          Container(
            height: 159.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Account Details:',style: TextStyle(fontSize: 24.sp),),
                Text('Name: Adeola\'s vault ',style: TextStyle(fontSize: 20.sp),),
                Text('Account Number: 3810030779',style: TextStyle(fontSize: 20.sp),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Available Balance: ',style: TextStyle(fontSize: 20.sp),),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.end,
                      style:TextStyle(fontSize: 18.sp) ,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      readOnly: true,
                      controller: vaultBalanceController,
                    ),
                  ),
                ],),
            ],),
          ),
          Container(
            margin: EdgeInsets.only(top: 73.h),
            height: 51.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kBlue),
              onPressed: ()  {
                Navigator.of(context).pushNamed('/AddFunds2');
              },
              child: Text('Add Funds',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
            ),
          )
      ],),
    ),);
  }
}
