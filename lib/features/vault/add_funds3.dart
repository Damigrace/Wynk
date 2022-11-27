import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../controllers.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class AddFunds3 extends StatefulWidget {
  AddFunds3({Key? key}) : super(key: key);

  @override
  State<AddFunds3> createState() => _AddFunds3State();
}

class _AddFunds3State extends State<AddFunds3> {
  int? selectedV;

  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Container(

      child: SingleChildScrollView(
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
              height: 317.h,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Amount', style: TextStyle(fontSize: 24.sp,color: kBlue,fontWeight: FontWeight.bold),),
                    Container(
                        margin: EdgeInsets.only(top: 28.h,bottom: 40.h),
                        height: 61.h,
                        width: 326.w,
                        decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: kGrey1),
                            color: kWhite),
                        child:Align(
                          alignment: Alignment.center,
                          child: TextField(maxLines:1 ,cursorHeight: 0,cursorWidth: 0,
                            onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                            autofocus: true,
                            keyboardType:TextInputType.numberWithOptions(),
                            style: TextStyle(fontSize: 28.sp,),
                            decoration:   InputDecoration.collapsed(
                                hintText:  '₦ 0',
                                hintStyle: const TextStyle(fontSize: 28,
                                    color: kBlack1
                                )),
                            controller: vaultFundController,),
                        )
                    ),
                    Container(
                      height: 50.h,
                      width: 318.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue),
                        onPressed: ()  {
                          Navigator.of(context).pushNamed('/AddFunds4');
                        },
                        child: Text('Submit',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                      ),
                    )
                  ],),
              ),
            ),
          ],),
      ),
    ),);
  }
}
