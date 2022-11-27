import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';

class AddFunds2 extends StatefulWidget {
   AddFunds2({Key? key}) : super(key: key);

  @override
  State<AddFunds2> createState() => _AddFunds2State();
}

class _AddFunds2State extends State<AddFunds2> {
  int? selectedV;

  @override
  Widget build(BuildContext context) {

    return Scaffold(body: SingleChildScrollView(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.h,left: 28.w),
            margin: EdgeInsets.only(top: 40.h),
            width: double.infinity,
            height: 505.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Funding Source:', style: TextStyle(fontSize: 24.sp,color: kBlue),),
                SizedBox(height: 32.h,),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      child: Radio<int>(

                        value: 5,
                        activeColor: kYellow,
                        groupValue: selectedV,
                        onChanged: (val){
                          print(val);
                          setState(() {
                            selectedV = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 9.w,),
                    Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),),
                  ],),
                SizedBox(height: 30.h,),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      child: Radio<int>(
                        visualDensity: VisualDensity(
                            vertical: VisualDensity.minimumDensity,
                            horizontal: VisualDensity.minimumDensity
                        ),
                        value: 0,
                        activeColor: kYellow,
                        groupValue: selectedV,
                        onChanged: (val){
                          print(val);
                          setState(() {
                            selectedV = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 9.w,),
                    Text('Bank Transfer',style: TextStyle(fontSize: 15.sp),),
                  ],),
                SizedBox(height: 30.h,),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      child: Radio<int>(
                        visualDensity: VisualDensity(
                            vertical: VisualDensity.minimumDensity,
                            horizontal: VisualDensity.minimumDensity
                        ),
                        value: 1,
                        activeColor: kYellow,
                        groupValue: selectedV,
                        onChanged: (val){
                          print(val);
                          setState(() {
                            selectedV = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 9.w,),
                    Text('Card',style: TextStyle(fontSize: 15.sp),),
                  ],),
                SizedBox(height: 30.h,),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      child: Radio<int>(

                        value: 2,
                        activeColor: kYellow,
                        groupValue: selectedV,
                        onChanged: (val){
                          print(val);
                          setState(() {
                            selectedV = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 9.w,),
                    Text('USSD',style: TextStyle(fontSize: 15.sp),),
                  ],),
                SizedBox(height: 30.h,),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      child: Radio<int>(

                        value: 3,
                        activeColor: kYellow,
                        groupValue: selectedV,
                        onChanged: (val){
                          print(val);
                          setState(() {
                            selectedV = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 9.w,),
                    Text('Mobile Wallet',style: TextStyle(fontSize: 15.sp),),
                  ],),
                SizedBox(height: 30.h,),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      child: Radio<int>(

                        value: 4,
                        activeColor: kYellow,
                        groupValue: selectedV,
                        onChanged: (val){
                          print(val);
                          setState(() {
                            selectedV = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 9.w,),
                    Text('Cash At Merchant',style: TextStyle(fontSize: 15.sp),),
                  ],),
                Container(
                  margin: EdgeInsets.only(top: 31.h),
                  height: 50.h,
                  width: 318.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kBlue),
                    onPressed: ()  {
                      Navigator.of(context).pushNamed('/AddFunds3');
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
