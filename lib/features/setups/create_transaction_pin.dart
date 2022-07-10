import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';
import '../../controllers.dart';
import '../../utilities/models/otp_field.dart';
import '../verification_feature/confirm_transaction_pin.dart';
class CreateTransactionPin extends StatefulWidget {
  const CreateTransactionPin({Key? key}) : super(key: key);

  @override
  State<CreateTransactionPin> createState() => _CreateTransactionPinState();
}

class _CreateTransactionPinState extends State<CreateTransactionPin> {
  String? otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: 9.h),
                  child: const UserTopBar()
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 6.h,top: 33.h,left: 26.w),
                  child: Text('Create Transaction Pin',style: TextStyle(fontSize:32.sp,color: Colors.black,fontWeight: FontWeight.w400),),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 26.w),
                  child: SizedBox(
                    width: 290.w,
                    child: Text('Keep this number safe,it\'s how you will authorize transaction',
                      style: TextStyle(fontSize: 15.sp,color: Colors.grey),),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 70.h,bottom: 25.h,left: 60.w,),
                  child: Form(child:
                  SizedBox(width: 271.w,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        otpField(textEditingController: fieldOne,),
                        otpField(textEditingController: fieldTwo,),
                        otpField(textEditingController: fieldThree,),
                        otpField(textEditingController: fieldFour,),
                      ],),
                  )),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 36.w,right: 35.w,top: 90.h),
                  child: SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary:kBlue
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            const ConfirmTransactionPin()
                        ));
                      },
                      child: Text('Continue',style: TextStyle(fontSize: 15.sp),),
                    ),
                  ),
                ),
              ],),
          ),
        ),
      ),
    );
  }
}
