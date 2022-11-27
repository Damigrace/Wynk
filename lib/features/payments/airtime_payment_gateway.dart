import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import '../landing_pages/home_main14.dart';
import 'mobile_recharge.dart';
class PaymentGateway extends StatelessWidget {
   PaymentGateway({Key? key,required this.function,this.future,this.details,required this. amount, required this.purpose}) : super(key: key);
  Function function;
  Future? future;
  String? details;
  String? amount;
  String? purpose;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print('getting data');
            if(snapshot.hasData){
              print('has data');
              print(snapshot.data);
              if(snapshot.data['statusCode'] == 200){
                refresh(context);
                return Center(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(children: [
                          Container(
                            width: 177.w,
                            height: 177.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(9)
                            ),
                            width: 150.w,
                            height: 150.w,
                            child: Image.asset('lib/assets/images/rides/wynkvaultwallet.png'),
                          ),

                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: SizedBox(
                                  width: 57.w,
                                  height: 57.w,
                                  child: Image.asset('lib/assets/images/airtime_logo/payment_success.png'))),
                        ],),
                        SizedBox(height: 27.h,),
                        Text('Success',
                          style: TextStyle(fontSize: 26.sp,color: Colors.green),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 10.h,),
                        Text.rich(

                          TextSpan(

                              style: TextStyle(fontSize: 14.sp,height: 1.3.h),
                              text: 'You have successfully paid a sum of NGN ',
                              children: [
                                WidgetSpan(child:
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(amount!, style: TextStyle(fontSize: 14.sp),),
                                    Text(' to Wynk for $purpose', style: TextStyle(fontSize: 14.sp),),
                                  ],
                                )
                                )
                              ]
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 54.h,),
                        GestureDetector(
                          onTap: (){{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                MobileRecharge()));
                          };},
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text('Make another payment',
                                style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                            ),
                          ),),
                        GestureDetector(
                          onTap:(){

                            //Navigator.pop(context);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                HomeMain14()));
                          } ,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical:15.h,horizontal: 40.w),
                            height: 50.h,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text('Go Home',
                                  style: TextStyle(fontSize: 15.sp)),
                            ),
                          ),),
                      ],),
                );
              }
              else{
                Future.delayed(Duration(milliseconds: 5),(){
                  showSnackBar(context, snapshot.data['errorMessage']);});
                return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text('Oops!!! \n Payment Unsuccessful!',
                          style: TextStyle(fontSize: 26.sp,color: Colors.red),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 30.h,),
                        GestureDetector(
                          onTap: (){{
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                MobileRecharge()));
                          };},
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text('Retry payment',
                                style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                            ),
                          ),),
                        GestureDetector(
                          onTap:(){
                            //Navigator.pop(context);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                HomeMain14()));
                          } ,
                          child: Container(

                            width: double.infinity,
                            height: 50.h,
                            margin: EdgeInsets.symmetric(vertical:15.h,horizontal: 40.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text('Go Home',
                                  style: TextStyle(fontSize: 15.sp)),
                            ),
                          ),),
                      ],),
                );
              }
            }
            return Center(child: Container(
              width: 230,height: 100,
              child: Column(
                children: [
                  Text('Routing to Payment Gateway.\nPlease wait…',textAlign: TextAlign.center,),
                  SizedBox(height: 10.h,),
                  SpinKitCircle(color: kYellow,),
                ],
              ),),);
          },)
    );
  }
}