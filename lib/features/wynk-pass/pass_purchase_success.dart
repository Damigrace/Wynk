import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class PassPurchaseConfirm extends StatefulWidget {
  PassPurchaseConfirm({Key? key}) : super(key: key);
  @override
  _PassPurchaseConfirmState createState() => _PassPurchaseConfirmState();
}

class _PassPurchaseConfirmState extends State<PassPurchaseConfirm> {
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
              SizedBox(height: 64.h,),
              Text('Success!',style: TextStyle(fontSize: 38.sp),),
              SizedBox(height: 42.h,),
              SizedBox(
                height: 51.h,
                width: double.infinity,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue
                  ),
                  onPressed:()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? wynkid =await prefs.getString('Origwynkid');
                    print(wynkid);
                    Navigator.pushNamedAndRemoveUntil(context,'/CaptainOnline' ,ModalRoute.withName('/CaptainHome'));
                  },
                  child: Text('Start Driving',style: TextStyle(fontSize: 18.sp),),
                ),
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
                  backgroundColor: kBlue),
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