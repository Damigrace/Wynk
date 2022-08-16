
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:untitled/utilities/models/lists.dart';
import 'package:untitled/utilities/widgets.dart';
import '../../controllers.dart';
import '../landing_pages/captain_home.dart';
Map? userData;

class CaptainFRegistration extends StatefulWidget {
  const CaptainFRegistration({Key? key}) : super(key: key);

  @override
  State<CaptainFRegistration> createState() => _CaptainFRegistrationState();
}

class _CaptainFRegistrationState extends State<CaptainFRegistration> {
  bool showSpinner=false;
  bool isHaveCar = false;
  String? selectedCarBrand;
  String? selectedCarModel;
  String? selectedCarYear;
  String? selectedColor;
  String? selectedCAssociation;
  String? Capacity;
  int? selectedV;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:   EdgeInsets.only(top:15.h,left:36.w ,right: 36.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(this.context),
                SizedBox(height: 33.h),
                Text('Add Your Vehicle...',style: kTextStyle1),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 62.h),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [AddTypeInputBox(hintText: 'Driver License Number',controller: emailController, textInputType: TextInputType.emailAddress,)])
                        ),
                        Container(
                          padding:  EdgeInsets.only(top: 30.h),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children:  [
                                    Expanded(
                                      child: Text('Select Association Type',
                                          style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                items:associationTypes.map((associationType) => DropdownMenuItem<String>(
                                    value: associationType,
                                    child: Text(
                                      associationType,
                                      overflow: TextOverflow.ellipsis,
                                    ))).toList(),
                                value: selectedCAssociation,
                                onChanged: (value){
                                  setState(() {
                                    selectedCAssociation=value as String;
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
                        ),
                        SizedBox(height: 33.h),
                        Text('Car Details',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        SizedBox(height: 23.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)
                              ),
                                activeColor: kYellow,
                                value: isHaveCar, onChanged:(value){
                              setState(() {
                                isHaveCar = value!;
                              });
                            }),
                          ),
                            SizedBox(width: 10.w),
                            Text('I don’t have a car',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400),),

                          ],),
                        SizedBox(height: 26.h),
                        Row(children: [
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children:  [
                                      Expanded(
                                        child: Text('Car Brand',
                                            style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  items:carBrands.map((carBrand) => DropdownMenuItem<String>(
                                      value: carBrand,
                                      child: Text(
                                        carBrand,
                                        overflow: TextOverflow.ellipsis,
                                      ))).toList(),
                                  value: selectedCarBrand,
                                  onChanged: (value){
                                    setState(() {
                                      selectedCarBrand=value as String;
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
                          ),
                          SizedBox(width:7.w),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children:  [
                                      Expanded(
                                        child: Text('Car Color',
                                            style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  items:carColors.map((carColor) => DropdownMenuItem<String>(
                                      value: carColor,
                                      child: Text(
                                        carColor,
                                        overflow: TextOverflow.ellipsis,
                                      ))).toList(),
                                  value: selectedColor,
                                  onChanged: (value){
                                    setState(() {
                                      selectedColor=value as String;
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
                          ),],),
                        SizedBox(height: 9.h),
                        Row(children: [
                          Expanded(
                            flex: 6,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children:  [
                                      Expanded(
                                        child: Text('Car Model',
                                            style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  items:carModels.map((carModel) => DropdownMenuItem<String>(
                                      value: carModel,
                                      child: Text(
                                        carModel,
                                        overflow: TextOverflow.ellipsis,
                                      ))).toList(),
                                  value: selectedCarBrand,
                                  onChanged: (value){
                                    setState(() {
                                      selectedCarBrand=value as String;
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
                          ),
                          SizedBox(width:7.w),
                          Expanded(
                            flex: 4,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children:  [
                                      Expanded(
                                        child: Text('Year',
                                            style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  items:carYears.map((carYear) => DropdownMenuItem<String>(
                                      value: carYear,
                                      child: Text(
                                        carYear,
                                        overflow: TextOverflow.ellipsis,
                                      ))).toList(),
                                  value: selectedColor,
                                  onChanged: (value){
                                    setState(() {
                                      selectedColor=value as String;
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
                          ),],),
                        SizedBox(height: 9.h),
                        Row(children: [
                          Expanded(
                            flex: 4,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children:  [
                                      Expanded(
                                        child: Text('Car Model',
                                            style:kTextStyle4.copyWith(fontWeight:FontWeight.w400,fontSize:15 ),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  items:carModels.map((carModel) => DropdownMenuItem<String>(
                                      value: carModel,
                                      child: Text(
                                        carModel,
                                        overflow: TextOverflow.ellipsis,
                                      ))).toList(),
                                  value: selectedCarBrand,
                                  onChanged: (value){
                                    setState(() {
                                      selectedCarBrand=value as String;
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
                          ),
                          SizedBox(width:7.w),
                          ElevatedInputBox(
                            flex: 6,
                            controller: licensePlateController,
                            textInputType: TextInputType.name,
                            hintText: 'License Plate',)]
                          ,),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h,bottom: 25.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ElevatedInputBox(hintText: 'Owner\'s Full Name',controller: emailController, textInputType: TextInputType.emailAddress,)])
                        ),
                        Text('Car Images',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  hintText: 'Front Image',
                                  controller: frontImageController,
                                  textInputType: TextInputType.name,
                                  readonly: false,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  hintText: 'Back Image',
                                  controller: backImageController,
                                  textInputType: TextInputType.name,
                                  readonly: false,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  hintText: 'Car Inspection',
                                  controller: inspectionController,
                                  textInputType: TextInputType.name,
                                  readonly: false,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  hintText: 'Vehicle License',
                                  controller: licensePlateController,
                                  textInputType: TextInputType.name,
                                  readonly: false,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h,bottom: 32.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  hintText: 'Vehicle Registration',
                                  controller: vehicleRegistrationController,
                                  textInputType: TextInputType.name,
                                  readonly: false,
                                ),])
                        ),
                        Padding(
                          padding:  EdgeInsets.only(bottom: 25.h),
                          child: Row(children: [
                            Radio<int>(
                              activeColor: kYellow,
                              toggleable: true,
                              onChanged: (value) {
                                setState(() {
                                  if(selectedV==0){selectedV=1;}else{selectedV=0;}
                                });
                              }, groupValue: selectedV, value: 1,

                            ),
                            Text('I accept Wynk\'s',style: TextStyle(fontSize: 15.sp),),
                            TextButton(onPressed: (){}, child: Text('Terms & Conditions',
                                style: TextStyle(fontSize: 15.sp,color: kYellow)))
                          ],),
                        ),
                        SizedBox(
                          height: 51.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kBlue),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('capRegStat', true);
                              setState(() {
                                showSpinner=true;
                              });
                              context.read<FirstData>().checkCapRegStat(true);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const CaptainHome()
                              ));
                              setState(() {
                                showSpinner=false;
                              });
                            },
                            child: Text('Continue',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 81.h,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}