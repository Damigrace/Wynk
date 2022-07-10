import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
import '../../controllers.dart';

class SignUpPersonalDetails extends StatefulWidget {
  const SignUpPersonalDetails({Key? key}) : super(key: key);

  @override
  State<SignUpPersonalDetails> createState() => _SignUpPersonalDetailsState();
}

class _SignUpPersonalDetailsState extends State<SignUpPersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:   EdgeInsets.only(top:15.h,left:36.w ,right: 36.w),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(this.context),
                  SizedBox(height: 33.h),
                  Text('Almost There...',style: kTextStyle1),
                  SizedBox(height: 95.h),
                  Row(children: [
                    InputBox(hintText: 'First Name', controller: firstNameController,),
                    SizedBox(width:7.w),
                    InputBox(hintText:' Last Name', controller: lastNameController)
                  ],),
                  Padding(
                      padding:  EdgeInsets.only(top: 9.h),
                      child: Flex(
                          direction: Axis.horizontal,
                          children: [InputBox(hintText: 'Email Address',controller: emailController,)])
                  ),
                  Padding(
                      padding:  EdgeInsets.only(top: 9.h),
                      child: Flex(
                          direction: Axis.horizontal,
                          children: [InputBox(hintText: 'Permanent Address',controller: permAddressController,)])
                  ),
                  Padding(
                      padding:  EdgeInsets.only(bottom: 187.h,top: 9.h),
                      child: Flex(
                          direction: Axis.horizontal,
                          children:[InputBox(hintText: 'ID Number',controller: idNumController,)])
                  ),
                  SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kBlue),
                      onPressed: (){},
                      child: Text('Continue',style: TextStyle(fontSize: 15.sp),),
                    ),
                  ),
                ],),
            ),
          ),
        ),
      ),
    );
  }
}