
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/models/data_confirmation.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
import '../../controllers.dart';
Map? userData;
dynamic  base64String;

class SignUpPersonalDetails extends StatefulWidget {
  const SignUpPersonalDetails({Key? key}) : super(key: key);

  @override
  State<SignUpPersonalDetails> createState() => _SignUpPersonalDetailsState();
}

class _SignUpPersonalDetailsState extends State<SignUpPersonalDetails> {
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                      InputBox(hintText: 'First Name', controller: firstNameController, textInputType: TextInputType.name),
                      SizedBox(width:7.w),
                      InputBox(hintText:' Last Name', controller: lastNameController, textInputType: TextInputType.name,)
                    ],),
                    Padding(
                        padding:  EdgeInsets.only(top: 9.h),
                        child: Flex(
                            direction: Axis.horizontal,
                            children: [InputBox(hintText: 'Email Address',controller: emailController, textInputType: TextInputType.emailAddress,)])
                    ),
                    Padding(
                        padding:  EdgeInsets.only(top: 9.h),
                        child: Flex(
                            direction: Axis.horizontal,
                            children: [InputBox(hintText: 'Permanent Address',controller: permAddressController, textInputType: TextInputType.streetAddress,)])
                    ),
                    Padding(
                        padding:  EdgeInsets.only(bottom: 187.h,top: 9.h),
                        child: Flex(
                            direction: Axis.horizontal,
                            children:[InputBox(hintText: 'Referral code',controller: refCodeController, textInputType: TextInputType.text,)])
                    ),
                    SizedBox(
                      height: 51.h,
                      width: double.infinity,
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue),
                        onPressed: ()async{
                          if(context.read<FirstData>().isReg==true){
                            showToast('You have a record in the database');
                            setState(() {
                              showSpinner=false;
                            });
                          }
                          context.read<FirstData>().getUsername(firstNameController.text);
                          spinner(context);
                          await getVerificationDetails(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const DataConfirmation()
                          ));
                          },
                        child: Text('Submit',style: TextStyle(fontSize: 15.sp),),
                      ),
                    ),
                  ],),
              ),
            ),
          ),
        ),
      ),
    );
  }
}