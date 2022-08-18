import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/payments/smile_sub_page.dart';
import 'package:untitled/features/payments/spectranet_sub.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import 'mobile_recharge.dart';
class InternetSubMain extends StatefulWidget {
  const InternetSubMain({Key? key}) : super(key: key);

  @override
  _InternetSubMainState createState() => _InternetSubMainState();
}

class _InternetSubMainState extends State<InternetSubMain> {

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
                Text('Internet\nSubcriptions',style: TextStyle(fontSize: 26.sp),),
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
                tiles: <ListTile> [
                  ListTile(
                    onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        SmileSubPage())),
                    contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/subscriptions/smile.jpg')),
                    title: Text('Smile Subscription',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(
                    onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        SpectranetSubPage())),
                    contentPadding: EdgeInsets.only(left: 36.w),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/subscriptions/spectra.jpg')),
                    title: Text('Spectranet Subscription',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding:EdgeInsets.only(left: 36.w),
                    onTap: ()=>showSnackBar(context, 'This is not available yet'),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/subscriptions/vdt.png')),
                    title: Text('VDTLTE Subscription',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    onTap: ()=>showSnackBar(context, 'This is not available yet'),
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/subscriptions/ntel.png')),
                    title: Text('NTEL Subscription',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    onTap: (){
                      context.read<FirstData>().saveSelNet(1);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MobileRecharge()));
                    },
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/quick_pay/image-6-1@1x.png')),
                    title: Text('MTN Data Plans',style: TextStyle(fontSize: 15.sp),),
                  ),
                  ListTile(contentPadding: EdgeInsets.only(left: 36.w),
                    onTap: (){
                      context.read<FirstData>().saveSelNet(2);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MobileRecharge()));
                    },
                    leading: SizedBox(
                        width: 26.w,
                        height: 26.w,
                        child: Image.asset('lib/assets/images/quick_pay/image-9-1@1x.png')),
                    title: Text('9Mobile Data Plans',style: TextStyle(fontSize: 15.sp),),
                  ),
                ]).toList(),)
        ],),
    ));
  }
}
