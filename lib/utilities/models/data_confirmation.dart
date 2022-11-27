import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wynk/controllers.dart';
import 'package:wynk/features/landing_pages/home_main14.dart';
import 'package:wynk/features/registration_feature/create_pin.dart';
import 'package:wynk/features/registration_feature/sign_up_personal_details.dart';
import 'package:wynk/main.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/constants/textstyles.dart';
import 'package:wynk/utilities/widgets.dart';
class DataConfirmation extends StatelessWidget {
  const DataConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 10.w,top: 10.h,right: 10.w ),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: (
                  Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  backButton(context),
                  SizedBox(height: 23.h,),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Confirm Your data...',style: TextStyle(fontSize: 32.sp),
                  ),),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 14.w,top: 53.h,bottom: 34.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: kGrey1),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        width:double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Please verify and confirm your data',style: kTextStyle3,),
                            SizedBox(height: 43.h,),
                            Padding(
                              padding:  EdgeInsets.only(left: 35),
                              child: Image.network(context.read<FirstData>().userImgUrl.toString(),width: 266.w,height: 163.h,),
                            )
                          ],),),
                      SizedBox(height: 21.h,),
                      Container(
                        padding: EdgeInsets.only(left: 14.w,top: 30.h,bottom: 34.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: kGrey1),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        width:double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Personal Information',style: kTextStyle3),
                            DetailsTile(controller: confirmationPhoneCont, title:'Phone number' , icondata:Icons.phone_android_rounded ,),
                            DetailsTile(controller:confirmationEmailCont , title: 'Email address', icondata:Icons.email_outlined ,),
                            DetailsTile(controller:confirmationFirstnameCont , title: 'First name', icondata: Icons.drive_file_rename_outline,),
                            DetailsTile(controller:confirmationLastnameCont , title: 'Last name', icondata:Icons.drive_file_rename_outline ,),
                            // DetailsTile(controller:confirmationStreetAddressCont , title: 'Street Address', icondata:Icons.location_on ,),
                            // DetailsTile(controller:confirmationCityCont , title:'City' , icondata:Icons.location_city ,),
                            // DetailsTile(controller: confirmationCountryCont, title: 'Country of residence', icondata: Icons.apartment_sharp,),
                            DetailsTile(controller:confirmationDobCont , title:'Date of Birth' , icondata: Icons.calendar_today,),
                            DetailsTile(controller:confirmationDocIDCont , title:'Document ID' , icondata:Icons.event_note_outlined ,),
                            SizedBox(height: 34.h,),
                            Container(
                              padding: EdgeInsets.only(left: 25.w,right: 25.w),
                              height: 51.h,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kBlue),
                                onPressed: ()async{
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) =>  CreateTPin()
                                  ));
                                },
                                child: Text('Submit',style: TextStyle(fontSize: 15.sp),),
                              ),
                            ),
                          ],),),
                    ],
                  ),
                ],
              )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

