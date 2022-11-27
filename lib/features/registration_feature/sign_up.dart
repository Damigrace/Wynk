import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/features/registration_feature/sign_up_personal_details.dart';
import 'package:wynk/main.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/constants/textstyles.dart';
import 'package:wynk/utilities/widgets.dart';
import '../../utilities/models/lists.dart';
import '../../controllers.dart';
import 'package:wynk/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String? selectedCaptainType;
  String? selectedIDType;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
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
                    child: Container(
                      width: 196.w,
                      child: Text('Almost there...',
                        style: kTextStyle1)),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 15.h,top: 58.h),
                    child: Text('Identity Verification',
                      style:kTextStyle3.copyWith(fontWeight: FontWeight.w400,fontSize: 20.sp))),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children:  [
                          Expanded(
                            child: Text('ID Type',
                              style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                              overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      items:iDTypes.map((iDType) => DropdownMenuItem<String>(
                          value: iDType,
                          child: Text(
                            iDType,
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
                    padding:  EdgeInsets.only(bottom: 341.h,top: 9.h),
                    child: Flex(
                        direction: Axis.horizontal,
                        children:[InputBox(
                          hintText: 'ID Number',controller: idNumController, textInputType: TextInputType.number,)] )
                  ),
                  SizedBox(
                    height: 51.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue),
                      onPressed: () async {
                        setState(() {
                          showSpinner=true;
                        });
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('Origwynkid',context.read<FirstData>().uniqueId!
                        );
                        switch(selectedIDType){
                          case 'National ID card': context.read<FirstData>().getSelectedId('nin');break;
                          case 'Bank Verification Number': context.read<FirstData>().getSelectedId('bvn');break;
                          default:context.read<FirstData>().getSelectedId('nin');
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpPersonalDetails()
                        ));
                        setState(() {
                          showSpinner=false;
                        });
                      },
                      child: Text('Continue',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                    ),
                  )
                ],),
            ),
          ),
        ),
      ),
    );
  }
}
