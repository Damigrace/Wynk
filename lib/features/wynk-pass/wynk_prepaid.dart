import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/features/landing_pages/captain_online.dart';
import 'package:untitled/features/wynk-pass/wynkpass_prepaid_confirmation.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../controllers.dart';
import '../../services.dart';
class PassPurchaseConfirmPrepaid extends StatefulWidget {
  PassPurchaseConfirmPrepaid({Key? key}) : super(key: key);
  @override
  _PassPurchaseConfirmPrepaidState createState() => _PassPurchaseConfirmPrepaidState();
}

class _PassPurchaseConfirmPrepaidState extends State<PassPurchaseConfirmPrepaid> {
  String? inputPin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 15.w,top: 10.h,right: 7.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    backButton(context),
                  ],),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.h),
                padding: EdgeInsets.only(top: 13.h),
                width: 218.w,
                height: 258.h,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10)
                ),
                child:
                Column(
                  children: [
                    Container(
                      width: 138.w,
                      height: 138.w,
                      child: CircleAvatar(
                        backgroundColor: context.watch<PassSubDetails>().passAvatarColor,
                        child: Image.asset(context.watch<PassSubDetails>().passLogo!,width: 106.w,height:41.h ,),
                      ),
                    ),
                    Text(context.watch<PassSubDetails>().passName!,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp),),
                    SizedBox(height: 3.h,),
                    Text('₦${context.watch<PassSubDetails>().passAmount!}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp),),
                    SizedBox(height: 10.h,),
                    Text('Valid for ${context.watch<PassSubDetails>().passDuration!}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13.sp),),
                  ],
                ),),
              SizedBox(height: 54.h,),
              Text('You Are Purchasing A ${context.read<PassSubDetails>().passName} Captain Pass!',style: TextStyle(fontSize: 15.sp),),
              SizedBox(height: 55.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 38.h,
                    width: 121.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.h)
                        ),
                          primary: kBlue
                      ),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>  PrepaidPassConfirmation()));
                      },
                      child: Text('Continue',style: TextStyle(fontSize: 18.sp),),
                    ),
                  ),
                  SizedBox(width: 11.w,),
                  SizedBox(
                    height: 38.h,
                    width: 121.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: kBlue),
                              borderRadius: BorderRadius.circular(19.h)
                          ),
                          primary: Colors.white
                      ),
                      onPressed:(){
                      },
                      child: Text('Cancel',style: TextStyle(fontSize: 18.sp,color: kBlue),),
                    ),
                  )
                ],
              ),
            ],),
        ),
      ),
    );
  }


}
Widget WhiteWynkPass(String price ) {

  return Container(
    child: Container(
      width: 144.w,
      height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: Color(0xff7574A0),
              child: Image.asset('lib/assets/images/wynk_pass/white_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text('Daily',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 3.h,),
          Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 10.h,),
          Text('Valid for 24 hours',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  primary: kBlue),
              onPressed: ()async{

              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],
      ),
    ),
  );
}

Container BlueWynkPass (String price){
  return Container(
    child: Container(
      width: 144.w,
      height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: kYellow,
              child: Image.asset('lib/assets/images/wynk_pass/blue_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text('Weekly',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 3.h,),
          Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 10.h,),
          Text('Valid for 7 days',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  primary: kBlue),
              onPressed: ()async{
              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],
      ),
    ),
  );
}

Container YellowWynkPass (String price){
  return Container(
    child: Container(
      width: 144.w,
      height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: kBlue,
              child: Image.asset('lib/assets/images/wynk_pass/yellow_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text('Monthly',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 3.h,),
          Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 10.h,),
          Text('Valid for 30 days',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  primary: kBlue),
              onPressed: ()async{
              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],
      ),
    ),
  );
}