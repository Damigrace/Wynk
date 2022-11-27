import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynk/features/payments/send_funds/data_topup.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import 'airtime_topup.dart';
class MobileRecharge extends StatefulWidget {
  const MobileRecharge({Key? key}) : super(key: key);

  @override
  _MobileRechargeState createState() => _MobileRechargeState();
}
int index = 0;
bool isAirtButPressed = true;
bool isDatButPressed = false;
final screens = [
  AirtimeTopUp(),
  DataTopUp()
];


class _MobileRechargeState extends State<MobileRecharge> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 36.w,vertical: 77.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 31.h,),
                Text('Mobile\nRecharge',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 10.h,),
                Container(
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.w),
                    color: kGrey1,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:(){
                            setState(() {
                              index = 0;
                              isAirtButPressed = true;
                              isDatButPressed = false;
                            });
                          },
                          child:Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color:  isAirtButPressed == true?kBlue:kGrey1
                              ),
                              alignment: Alignment.center,
                            height: double.infinity,
                              child: Text('Airtime',style: TextStyle(
                                  color: Colors.white,
                                  fontSize:18.sp,fontWeight: FontWeight.w600 ),)),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap:(){
                        setState(() {
                        index = 1;
                        isAirtButPressed = false;
                        isDatButPressed = true;
                        });
                        },
                        child:Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.w),
                                color:  isDatButPressed == true?kBlue:kGrey1
                            ),
                          alignment: Alignment.center,
                          height: double.infinity,
                            child: Text('Data',style: TextStyle(
                                color: Colors.white,
                                fontSize:18.sp,fontWeight: FontWeight.w600 ))),
                        ),
                      ),

                    // Expanded(
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           elevation: 0,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(5.w)
                    //           ),
                    //           backgroundColor: isAirtButPressed == true?kBlue:Colors.white),
                    //       onPressed: (){setState(() {
                    //         index = 0;
                    //         isAirtButPressed = true;
                    //         isDatButPressed = false;
                    //       });},
                    //       child: Text('Airtime',style: TextStyle(
                    //       color: isAirtButPressed == true?Colors.white:kGrey1,
                    //           fontSize:18.sp,fontWeight: FontWeight.w600 ),)),
                    // ),


                    // Expanded(
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           elevation: 0,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(5.w)
                    //           ),
                    //           backgroundColor: isDatButPressed == true?kBlue:Colors.white),
                    //       onPressed: (){
                    //         setState(() {
                    //           index = 1;
                    //           isAirtButPressed = false;
                    //           isDatButPressed = true;
                    //         });
                    //       }, child: Text('Data',style: TextStyle(
                    //       color: isDatButPressed == true?Colors.white:kGrey1,
                    //       fontSize:18.sp,fontWeight: FontWeight.w600 ))),
                    // ),
                  ],),
                ),
                SizedBox(height: 20.h,),
                IndexedStack(
                  children: screens,
                  index: index,
                )


              ],
            ),
          ),
        ],),
    ));
  }
}

