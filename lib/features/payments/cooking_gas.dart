import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/payments/payment_list.dart';
import 'package:untitled/features/payments/total_gas.dart';
import 'package:untitled/main.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
class CookingGas extends StatefulWidget {
  const CookingGas({Key? key}) : super(key: key);

  @override
  _CookingGasState createState() => _CookingGasState();
}

class _CookingGasState extends State<CookingGas> {
  String? pin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 36.w,right:36.w,top: 77.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 31.h,),
                Text('Cooking\nGas',style: TextStyle(fontSize: 26.sp),),
                Container(
                    margin: EdgeInsets.only(bottom: 32.h,top: 33.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 61.h,
                    width: 318.w,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: kGrey1),
                        color: kWhite),
                    child:Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(Icons.search,color: kGrey1,),
                          SizedBox(width: 15.w,),
                          Expanded(
                            child: TextField(
                              maxLines:1 ,
                              cursorHeight: 0,
                              cursorWidth: 0,
                              onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                              autofocus: false,
                              keyboardType:TextInputType.text,
                              style: TextStyle(fontSize: 15.sp,),
                              decoration:   InputDecoration.collapsed(
                                  hintText:  'Enter to start searching',
                                  hintStyle:  TextStyle(fontSize: 15.sp,
                                      color: kBlack1
                                  )),),
                          ),
                        ],
                      ),
                    )
                ),
                Text('Select Vendor',style: TextStyle(fontSize: 12.5.sp),),
                SizedBox(height: 15.h,),

              ],
            ),
          ),
          Column(
            children:
            ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(

                    contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/forte2.jpg')),
                    title: Text('Forte Gas Line',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding:EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/spgs.png')),
                    title: Text('SPGS Gas',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/ibile2.jpg')),
                    title: Text('IBILE Gas',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(
                    onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        TotalGas())),
                    contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/total.png')),
                    title: Text('Total Gas',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),                    leading: SizedBox(
                      width: 26.w,
                      height: 26.w,
                      child: Image.asset('lib/assets/images/payments/mobil-logo.png')),
                    title: Text('Mobil Gas',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(),
                    title: SizedBox(),
                  ),
                ]).toList(),)
        ],),
    ));
  }
}
