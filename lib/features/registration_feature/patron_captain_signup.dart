import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/widgets.dart';

import '../../main.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../landing_pages/captain_home.dart';
class UserSelector extends StatefulWidget {
  const UserSelector({Key? key}) : super(key: key);

  @override
  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  var userPImage;
  void initState() {
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
  int? usertype;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: 
    
    SingleChildScrollView(
        padding:  EdgeInsets.only(top: 20.h,left: 26.w,right: 26.w),
      child: SizedBox(height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(context),
            Padding(
            padding:  EdgeInsets.only(top: 16.h,left: 10.w,bottom: 33.h),
            child: Text(' Profile',style: (TextStyle(fontSize: 26.sp)),),
          ),
            Center(child: CircleAvatar(
              backgroundImage:MemoryImage(userPImage),
              radius: 51.r ,)),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/icon-awesome-crown-1@1x.jpg',width: 16.w,height: 13.h,),
                Text('Gold Member',style: (TextStyle(fontSize: 13.sp)),),
              ],),
            SizedBox(height: 33.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: [
                  Radio(value: 1, groupValue: usertype, onChanged: (value){

                    setState(() {
                      usertype=1;
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeMain14()));
                  }),Text('Patron',style: (TextStyle(fontSize: 18.sp)))
                ],
              ),
              Row(
                children: [
                  Radio(value: 2, groupValue: usertype, onChanged: (value)async{
                    setState(() {
                      usertype=2;
                    });
                   var currentLocation = await determinePosition(context);
                    context.read<FirstData>().saveCurrentLocat(currentLocation.latitude, currentLocation.longitude);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CaptainHome()));
                  }),Text('Captain',style: (TextStyle(fontSize: 18.sp)))
                ],
              )

            ],),
            readOnlyInputBox(hintText: fullnameCont.text, controller: fullnameCont, textInputType: TextInputType.name),
            readOnlyInputBox(hintText: emailController.text, controller: emailController, textInputType: TextInputType.emailAddress),
            readOnlyInputBox(hintText: confirmationPhoneCont.text, controller: confirmationPhoneCont, textInputType: TextInputType.number),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  height: 61.h,
                  width: double.infinity,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: kGrey1),
                      color: kWhite),
                  child:Row(children: [
                    SizedBox(width: 18.w,),
                    Expanded(
                      child: TextField(
                        obscureText: true,
                        readOnly: true,
                        onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                        autofocus: true,
                        style: kTextStyle5,
                        decoration:   InputDecoration.collapsed(
                            hintText: confirmTPinController.text,
                            hintStyle: const TextStyle(fontSize: 15,
                                color: kBlack1
                            )),
                        controller: confirmTPinController,),
                    )
                  ],
                  )
              )),
            readOnlyInputBox(hintText: idNumController.text, controller: idNumController, textInputType: TextInputType.number),
          ],),
      ),
    ),),);
  }
}
