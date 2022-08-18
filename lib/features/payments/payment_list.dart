import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/payments/cable_tv.dart';
import 'package:untitled/features/payments/power_topup.dart';
import 'package:untitled/features/payments/govt_bill.dart';
import 'package:untitled/features/payments/mobile_recharge.dart';
import 'package:untitled/features/payments/lasu_sf.dart';
import 'package:untitled/features/payments/school_fees_payment.dart';
import 'package:untitled/features/payments/utility_main.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
import '../landing_pages/home_main14.dart';
import 'internet_sub_main.dart';
class PaymentList extends StatefulWidget {
  const PaymentList({Key? key}) : super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  String? pin;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            HomeMain14()), (Route<dynamic> route) => false);
        return false;},
      child: Scaffold(
          body: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select\nPayment',style: TextStyle(fontSize: 26.sp),),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kYellow,
                            padding: EdgeInsets.symmetric(vertical: 19.h,horizontal: 17.w)
                          ),
                          onPressed: (){}, child: Text('Pay Merchant'))
                    ],
                  ),
                  SizedBox(height: 27.h,),
                  GestureDetector(
                    onTap: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        InternetSubMain()),),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
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
                                readOnly: true,
                                onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                style: TextStyle(fontSize: 15.sp),
                                decoration:   InputDecoration.collapsed(
                                    hintText: 'Internet Subscription',
                                    hintStyle:  TextStyle(fontSize: 15.sp,
                                        color: Colors.black
                                    ))),
                          ),
                          Icon(
                              Icons.keyboard_arrow_right
                          ),
                          SizedBox(width: 45.w,),
                        ],
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        MobileRecharge()),),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
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
                                readOnly: true,
                                onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                style: TextStyle(fontSize: 15.sp),
                                decoration:   InputDecoration.collapsed(
                                    hintText: 'Mobile Recharge',
                                    hintStyle:  TextStyle(fontSize: 15.sp,
                                        color: Colors.black
                                    ))),
                          ),
                          Icon(
                              Icons.keyboard_arrow_right
                          ),
                          SizedBox(width: 45.w,),
                        ],
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:  ()async{
                      spinner(context);
                      context.read<FirstData>().utilities.clear();
                     final response = await getUtilities();
                     if(response['statusCode'] == 200){
                       List res = response['message'];
                       res.forEach((element) {
                         var iniListTile = ListTile(
                           contentPadding: EdgeInsets.only(left: 36.w),
                           onTap: (){
                             context.read<FirstData>().saveServiceUnit(element['short_name']);
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>PowerUtilityMain()),);
                           },
                           leading: SizedBox(
                               width: 26.w,
                               height: 26.w,
                               child: Image.asset('lib/assets/images/payments/elec.png')),
                           title: Text(element['name'],style: TextStyle(fontSize: 15.sp),),
                         );
                         context.read<FirstData>().saveUtil(iniListTile);
                       });
                       Navigator.pop(context);
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) =>UtilityMain()),);
                     }
                     else{
                       showSnackBar(context, response['errorMessage']);
                       Navigator.pop(context);
                      }
                    },

                    child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
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
                                readOnly: true,
                                style: TextStyle(fontSize: 15.sp),
                                decoration:   InputDecoration.collapsed(
                                    hintText: 'Utility Bills',
                                    hintStyle:  TextStyle(fontSize: 15.sp,
                                        color: Colors.black
                                    ))),
                          ),
                          Icon(
                              Icons.keyboard_arrow_right
                          ),
                          SizedBox(width: 45.w,),
                        ],
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        GovtBill()),),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
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
                                readOnly: true,
                                onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                style: TextStyle(fontSize: 15.sp),
                                decoration:   InputDecoration.collapsed(
                                    hintText: 'Government Bills',
                                    hintStyle:  TextStyle(fontSize: 15.sp,
                                        color: Colors.black
                                    ))),
                          ),
                          Icon(
                              Icons.keyboard_arrow_right
                          ),
                          SizedBox(width: 45.w,),
                        ],
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:  ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        CableTv()),),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
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
                                readOnly: true,
                                onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                style: TextStyle(fontSize: 15.sp),
                                decoration:   InputDecoration.collapsed(
                                    hintText: 'Cable TV',
                                    hintStyle:  TextStyle(fontSize: 15.sp,
                                        color: Colors.black
                                    ))),
                          ),
                          Icon(
                              Icons.keyboard_arrow_right
                          ),
                          SizedBox(width: 45.w,),
                        ],
                        )
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 14.h),
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
                              readOnly: true,
                              onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                              style: TextStyle(fontSize: 15.sp),
                              decoration:   InputDecoration.collapsed(
                                  hintText: 'Religious Institution',
                                  hintStyle:  TextStyle(fontSize: 15.sp,
                                      color: Colors.black
                                  ))),
                        ),
                        Icon(
                            Icons.keyboard_arrow_right
                        ),
                        SizedBox(width: 45.w,),
                      ],
                      )
                  ),
                  GestureDetector(
                    onTap: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        SchoolFeesPayment()),),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
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
                                readOnly: true,
                                onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                style: TextStyle(fontSize: 15.sp),
                                decoration:   InputDecoration.collapsed(
                                    hintText: 'Tuition/School Fees',
                                    hintStyle:  TextStyle(fontSize: 15.sp,
                                        color: Colors.black
                                    ))),
                          ),
                          Icon(
                              Icons.keyboard_arrow_right
                          ),
                          SizedBox(width: 45.w,),
                        ],
                        )
                    ),
                  )
                ],
              ),
            ),
          ],),
      )),
    );
  }
}
