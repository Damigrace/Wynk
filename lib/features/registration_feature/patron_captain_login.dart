import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import '../../utilities/widgets.dart';
import '../landing_pages/captain_home.dart';
import '../landing_pages/home_main14.dart';
import 'captain_f_registration.dart';
class UserSelector extends StatefulWidget {
  const UserSelector({Key? key}) : super(key: key);

  @override
  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  var userPImage;
  void initState() {
    print(context.read<FirstData>().userType!);
    // TODO: implement initState
    super.initState();
    String profileImg=context.read<FirstData>().userImgUrl.toString();
    userPImage =base64Decode(profileImg);
  }
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
              radius: 51.r,
                backgroundColor: kBlue,
                child: CircleAvatar(
                  radius: 48.r,
                  backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),))),
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
                  Radio(
                      activeColor: kYellow,
                      value: 3, groupValue: int.parse(context.read<FirstData>().userType!), onChanged: (value){
                   // setState(() {usertype=2;});
                    context.read<FirstData>().saveUserType('3');
                    print('current usertype: ${context.read<FirstData>().userType}');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeMain14()));}),
                  Text('Patron',style: (TextStyle(fontSize: 18.sp)))
                ],
              ),
              Row(
                children: [
                  Radio(
                      activeColor: kYellow,
                      value: 2, groupValue: int.parse(context.read<FirstData>().userType!), onChanged: (value)async{
                   // setState(() {usertype=2;});

                    print('current usertype: ${context.read<FirstData>().userType}');
                    showDialog(
                        context: context, builder: (context){
                      return Container(child:
                      SpinKitThreeInOut(
                        color: kYellow,
                      ),);
                    });

                    if(context.read<FirstData>().origUserType! == '2'){
                      var currentLocation = await determinePosition(context);
                      context.read<FirstData>().saveCurrentLocat(currentLocation.latitude, currentLocation.longitude);
                      context.read<FirstData>().saveUserType('2');
                      Navigator.pop(context);
                      if(context.read<FirstData>().capOnline == true){
                        Navigator.pushNamed(context, '/CaptainOnline');
                      }
                      else{
                        Navigator.pushNamed(context, '/CaptainHome');
                      }

                    }
                  else{
                    if(context.read<FirstData>().lat != null){
                      Map<String,dynamic> ass = await getAssociation();
                        Map<String,dynamic> carType = await getCArType();
                        Map<String,dynamic> carModel = await getCarModel(1);
                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            CaptainFRegistration(
                          ass: ass,
                          carType: carType,
                          carModel: carModel,)
                        ));
                    }
                  else{
                      var currentLocation = await determinePosition(context);
                      context.read<FirstData>().saveCurrentLocat(currentLocation.latitude, currentLocation.longitude);
                      Map<String,dynamic> ass = await getAssociation();
                      Map<String,dynamic> carType = await getCArType();
                      Map<String,dynamic> carModel = await getCarModel(1);
                      Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          CaptainFRegistration(
                            ass: ass,
                            carType: carType,
                            carModel: carModel,)
                      ));
                    }}
                  }),
                  Text('Captain',style: (TextStyle(fontSize: 18.sp)))
                ],
              )

            ],),
            readOnlyInputBox(hintText: fullnameCont.text, controller: fullnameCont),
            readOnlyInputBox(hintText: emailController.text, controller: emailController),
            readOnlyInputBox(hintText: confirmationPhoneCont.text, controller: confirmationPhoneCont),
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
            readOnlyInputBox(hintText: idNumController.text, controller: idNumController),
          ],),
      ),
    ),),);
  }
}
