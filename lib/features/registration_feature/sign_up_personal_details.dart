
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
import 'create_pin.dart';
import 'otherRegNIn.dart';
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
                          int res = await getVerificationDetails(context);
                          Navigator.pop(context);
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (context) => const DataConfirmation()
                          // ))
                          if(res == 1){
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text('Confirm Details',style: kBoldBlack.copyWith(fontSize: 22.sp),),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 150.w,
                                    height: 2,
                                    color: kYellow,
                                  ),
                                  SizedBox(height: 15.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Name:',style: kBoldBlack,),
                                    Expanded(
                                      child: Container(
                                          child: Text('${confirmationFirstnameCont.text} ${confirmationLastnameCont.text}',style: kBoldBlack,)),
                                    )
                                  ],
                                ),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Birth Date',style: kBoldBlack,),
                                      Text(confirmationDobCont.text,style: kBoldBlack,)
                                    ],
                                  ),
                                  SizedBox(height: 15.h,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50.h,
                                      width: 241.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kBlue),
                                        onPressed: ()  async{
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) =>  CreateTPin()
                                          ));
                                        },
                                        child: Text('Confirm',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                                      ),
                                    ),
                                  )
                              ],),

                            );
                          });}
                          else if (res == 2){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const OtherRegNin()
                            ));
                          };
                          },
                        child: Text('Next',style: TextStyle(fontSize: 15.sp),),
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