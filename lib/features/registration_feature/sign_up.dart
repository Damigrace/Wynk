import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/features/registration_feature/sign_up_personal_details.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
import '../../utilities/models/lists.dart';
import '../../controllers.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? selectedCaptainType;
  String? selectedIDType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding:   EdgeInsets.only(top:15.h,left:36.w ,right: 36.w),
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 36.h,width: 36.h,
                  decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(5)),
                  child: GestureDetector(
                    child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30.w,),
                    onTap: ()=>Navigator.pop(context))
                ),
                SizedBox(height: 33.h),
                SizedBox(
                  height: 70.h,
                  width: 196.w,
                  child: Text('Let\'s make you a captain',
                    style: kTextStyle1)),
                SizedBox(height: 52.h),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text('Captain Type',
                            style: kTextStyle4,
                            overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    items:captainTypes.map((capType) => DropdownMenuItem<String>(
                      value: capType,
                        child: Text(
                          capType,
                          overflow: TextOverflow.ellipsis,
                        ))).toList(),
                    value: selectedCaptainType,
                    onChanged: (value){
                      setState(() {
                        selectedCaptainType=value as String;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_sharp),
                    iconSize: 30.h,
                    iconEnabledColor:kGrey1,
                    iconDisabledColor: kGrey1,
                    buttonHeight: 61.h,
                    buttonWidth: double.infinity,
                    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Colors.black26),
                      color: kWhite),
                    buttonElevation: 2,
                    itemHeight: 40,
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 200,
                    dropdownWidth: 200,
                    dropdownPadding: null,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: kWhite),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                    offset: const Offset(-20, 0),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 15.h,top: 42.h),
                  child: Text('Identity Verification',
                    style:kTextStyle3)),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children:  [
                        Expanded(
                          child: Text('Identification Type',
                            style:kTextStyle4,
                            overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    items:iDTypes.map((capType) => DropdownMenuItem<String>(
                        value: capType,
                        child: Text(
                          capType,
                          overflow: TextOverflow.ellipsis,
                        ))).toList(),
                    value: selectedIDType,
                    onChanged: (value){
                      setState(() {
                        selectedIDType=value as String;
                      });
                    },
                    icon: const Icon(
                        Icons.keyboard_arrow_down_sharp
                    ),
                    iconSize: 30.h,
                    iconEnabledColor: kGrey1,
                    iconDisabledColor:kGrey1,
                    buttonHeight: 61.h,
                    buttonWidth: double.infinity,
                    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Colors.black26),
                      color: kWhite),
                    buttonElevation: 2,
                    itemHeight: 40,
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 200,
                    dropdownWidth: 200,
                    dropdownPadding: null,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color:kWhite),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                    offset: const Offset(-20, 0)),
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 187.h,top: 9.h),
                  child: Flex(
                      direction: Axis.horizontal,
                      children:[InputBox(hintText: 'ID Number',controller: idNumController,)] )
                ),
                SizedBox(
                  height: 51.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kBlue),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpPersonalDetails()
                      ));
                    },
                    child: Text('Continue',style: TextStyle(fontSize: 15.sp),),
                  ),
                ),
              Padding(
                padding:  EdgeInsets.only(top: 17.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('Already a user? ',style: TextStyle(fontSize: 20.sp),),
                  TextButton(onPressed: (){}, child: Text('Login',style: TextStyle(fontSize: 20.sp,)))
                ],),
              )
              ],),
          ),
        ),
      ),
    );
  }
}
