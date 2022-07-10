import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';

import '../verification_feature/verification.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool checkboxState=false;
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 backButton(context),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 35.h,top: 33.h),
                    child: SizedBox(
                        height: 70.h,
                        width: 112.w,
                        child: Text('Let\'s get started',
                          style: kTextStyle1)),
                  ),
                  Container(
                    height: 71.h,
                    margin: const EdgeInsets.only(top: 9),
                    child: IntlPhoneField(
                      autovalidateMode: AutovalidateMode.disabled,
                      flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration:  InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        counter: const Offstage(),
                        labelText: 'Mobile Number',
                        labelStyle: const TextStyle(color: Color(0xffAFAFB6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      showDropdownIcon: true,
                      dropdownIconPosition:IconPosition.trailing,
                      onChanged: (phone) {
                      },
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 268.h,bottom: 24.h),
                    child: Row(children: [
                      Checkbox(value: checkboxState, onChanged:(value){
                        setState(() {
                          checkboxState==false?checkboxState=true:checkboxState=false;
                        });
                      } ),
                      Text('I accept Wynk\'s',style: TextStyle(fontSize: 16.sp),),
                      TextButton(onPressed: (){}, child: Text('Terms & Conditions',
                          style: TextStyle(fontSize: 16.sp,color: kYellow)))
                    ],),
                  ),
                  SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kBlue
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            const Verification()
                        ));
                      },
                      child: Text('Register',style: TextStyle(fontSize: 18.sp),),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 46.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already a user?',style: TextStyle(fontSize: 20.sp),),
                        TextButton(onPressed: (){}, child: Text('Login',
                            style: TextStyle(
                                fontSize: 20.sp,
                                color:kYellow)))
                      ],),
                  )
                ],),
            ),
          ),
        ),
      ),
    );
  }
}
