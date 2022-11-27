import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class GovtBill extends StatefulWidget {
  const GovtBill({Key? key}) : super(key: key);

  @override
  _GovtBillState createState() => _GovtBillState();
}

class _GovtBillState extends State<GovtBill> {

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
                Text('Government\nBills',style: TextStyle(fontSize: 26.sp),),
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
                Text('Select Biller',style: TextStyle(fontSize: 12.5.sp),),
                SizedBox(height: 15.h,),

              ],
            ),
          ),
          Column(
            children:
            ListTile.divideTiles(
                context: context,
                tiles: [
                  // ListTile(
                  //   onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  //       LagosLUC())),
                  //   contentPadding: EdgeInsets.only(left: 36.w),
                  //   leading: SizedBox(
                  //       width: 26.w,
                  //       height: 26.w,
                  //       child: Image.asset('lib/assets/images/payments/lluc.png')),
                  //   title: Text('Lagos State Land Use Charge',style: TextStyle(fontSize: 15.sp),),
                  // ),
                  ListTile(contentPadding:EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/frsc.png')),
                    title: Text('FRSC',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/firs.png')),
                    title: Text('FIRS Tax',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/payments/lawma.png')),
                    title: Text('Lagos State Waste BIll',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),                    leading: SizedBox(
                      width: 26.w,
                      height: 26.w,
                      child: Image.asset('lib/assets/images/payments/aluc.png')),
                    title: Text('Abuja Land Use Charge',style: TextStyle(fontSize: 15.sp),),
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
