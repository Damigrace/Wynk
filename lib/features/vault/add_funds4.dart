import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:untitled/features/vault/add_funds5.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
import '../../utilities/constants/textstyles.dart';
class AddFunds4 extends StatefulWidget {
  AddFunds4({Key? key}) : super(key: key);

  @override
  State<AddFunds4> createState() => _AddFunds4State();
}

class _AddFunds4State extends State<AddFunds4> {
  int? selectedV;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 27.w,vertical: 41.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.h,left: 28.w),
            margin: EdgeInsets.only(top: 40.h),
            width: double.infinity,
            height: 566.h,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter Your Card Details', style: TextStyle(fontSize: 24.sp,color: kBlue,fontWeight: FontWeight.bold),),
                SizedBox(height: 28.h,),
                FlexlessInputBox(
                    hintText: 'Name',
                    controller: cardNameCont,
                    textInputType: TextInputType.name),
                FlexlessInputBox(
                    hintText: 'Card Number',
                    controller: cardNumCont,
                    textInputType: TextInputType.numberWithOptions()),
                FlexlessInputBox(
                    hintText: 'Expiry Date',
                    controller: expDateCont,
                    textInputType: TextInputType.datetime),
                FlexlessInputBox(
                    hintText: 'CVV',
                    controller: cVVCont,
                    textInputType: TextInputType.number),
                Container(
                  height: 50.h,
                  width: 318.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kBlue),
                    onPressed: ()  {
                      Navigator.of(context).pushNamed('/AddFunds5');
                    },
                    child: Text('Submit',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                  ),
                )
              ],),
          ),
        ],),
    ),);
  }
}
