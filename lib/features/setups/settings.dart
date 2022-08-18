import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/setups/reset_pin.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
import 'dart:io';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../registration_feature/patron_captain_login.dart';
class Settings extends StatefulWidget {
   Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> settingsItem = [
    "Change Pin",
    "Wynk Switch",
    "Change Profile Picture"
  ];

   int? picUploadMode;

   File? imageFile;

   userUmageAsString()async{
     File? uImage=context.read<FirstData>().providerImage;
     final bytes = await File(uImage!.path).readAsBytes();
     String userImg64 = base64Encode(bytes);
     return userImg64;
   }

   getPicture()async{
     XFile? pickedFile=await ImagePicker().pickImage(
         source: picUploadMode == 0?ImageSource.camera:ImageSource.gallery);
     if(pickedFile != null){
       imageFile=File(pickedFile.path);
       context.read<FirstData>().imageGotten(imageFile);
     }
   }

   picturing(BuildContext context)async{
     BuildContext myC = this.context;
     showModalBottomSheet(
         enableDrag: false,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
         ),
         context: context,
         builder: (context){
           return Container(
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   ListTile(
                     leading:  CircleAvatar(
                         backgroundColor: kBlue,
                         child: Icon(Icons.camera_alt)),
                     title: Text('Take Photo'),
                     onTap: ()async{

                       Navigator.pop(context);
                       picUploadMode = 0;
                       spinner(myC);
                       final prefs = await SharedPreferences.getInstance();
                       await getPicture();
                       print('1');
                       String user64Img= await userUmageAsString();
                       print('2');
                       final res = await savePicture(user64Img, prefs.getString('Origwynkid')!);
                       if(res['statusCode'] == 200){showToast('Your profile picture has been successfully updated');}
                       Navigator.pop(myC);
                       imageCache.clear();
                       imageCache.clearLiveImages();
                     },
                   ),
                   ListTile(
                     leading: CircleAvatar(
                         backgroundColor: kBlue,
                         child: Icon(Icons.folder)),
                     title: Text('Upload Photo'),
                     onTap: ()async{
                       Navigator.pop(context);
                       picUploadMode = 1;
                       spinner(myC);
                       final prefs = await SharedPreferences.getInstance();
                       await getPicture();
                       String user64Img= await userUmageAsString();
                      final res = await savePicture(user64Img, prefs.getString('Origwynkid')!);
                       if(res['statusCode'] == 200){showToast('Your profile picture has been successfully updated');}

                       imageCache.clear();
                       imageCache.clearLiveImages();
                       Navigator.pop(myC);
                     },
                   )
                 ],)
           );
         });

   }

   void settingsSelect(int index, BuildContext context)async{
     print(index);

     switch(index){
       case 0: await showDialog(
           barrierDismissible: false,
           context: context, builder: (context){
         return AlertDialog(
           contentPadding: EdgeInsets.all(30.w),
           shape:  RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(18)
           ),
           content: Container(
             width: 301.w,
             height:270.h,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Enter Old PIN',
                           style: TextStyle(fontSize: 18.sp),textAlign: TextAlign.center,),
                         SizedBox(height: 13.h,),

                       ],),
                     GestureDetector(
                       onTap: ()=>Navigator.pop(context),
                       child: SizedBox(
                           width: 42.w,
                           height: 42.w,
                           child: Image.asset('lib/assets/images/rides/cancel1.png')),
                     )
                   ],),

                 Align(
                   alignment: Alignment.center,
                   child: Container(
                     margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
                     height: 61.h,
                     width: 260.w,
                     decoration:  BoxDecoration(
                       borderRadius: BorderRadius.circular(7),),
                     child: PinCodeTextField(
                       showCursor: true,
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       autoUnfocus: true,
                       autoDisposeControllers: false,
                       keyboardType: TextInputType.number,
                       onChanged: (v){},
                       autoFocus: true,
                       length: 4,
                       obscureText: true,
                       animationType: AnimationType.fade,
                       pinTheme: PinTheme(
                         activeFillColor: kWhite,
                         inactiveFillColor: kWhite,
                         selectedFillColor: kWhite,
                         activeColor: kGrey1,
                         inactiveColor: kGrey1,
                         selectedColor: kGrey1,
                         shape: PinCodeFieldShape.box,
                         borderRadius: BorderRadius.circular(5),
                         fieldHeight: 61.h,
                         fieldWidth: 51.w,
                       ),
                       animationDuration: Duration(milliseconds: 300),
                       controller: tripPinController,
                       onCompleted: (v) async{
                       },
                       beforeTextPaste: (text) {
                         print("Allowing to paste $text");
                         //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                         //but you can show anything you want here, like your pop up saying wrong paste format or etc
                         return true;
                       }, appContext: context,
                     ),
                   ),
                 ),
                 SizedBox(height:47.h),
                 Align(
                   alignment: Alignment.center,
                   child: Container(
                     height: 50.h,
                     width: 241.w,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: kBlue),
                       onPressed: () async {

                         spinner(context);
                         Map loginResponse = await sendLoginDetails(pin: tripPinController.text);
                         transactionPinController.clear();
                         if(loginResponse['statusCode'] != 200){
                           Navigator.pop(context);
                           showSnackBar(context, 'Seems you entered the wrong pin');
                         }
                         else{
                           Navigator.pop(context);
                           Navigator.pop(context);
                           showDialog(
                               barrierDismissible: false,
                               context: context, builder: (context){
                             return AlertDialog(
                               contentPadding: EdgeInsets.all(30.w),
                               shape:  RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(18)
                               ),
                               content: Container(
                                 width: 301.w,
                                 height:270.h,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text('Enter New PIN',
                                         style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
                                         GestureDetector(
                                           onTap: ()=>Navigator.pop(context),
                                           child: SizedBox(
                                               width: 42.w,
                                               height: 42.w,
                                               child: Image.asset('lib/assets/images/rides/cancel1.png')),
                                         ),
                                       ],
                                 ),
                                     Align(
                                       alignment: Alignment.center,
                                       child: Container(
                                         margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
                                         height: 61.h,
                                         width: 260.w,
                                         decoration:  BoxDecoration(
                                           borderRadius: BorderRadius.circular(7),),
                                         child: PinCodeTextField(
                                           showCursor: true,
                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                           autoUnfocus: true,
                                           autoDisposeControllers: false,
                                           keyboardType: TextInputType.number,
                                           onChanged: (v){},
                                           autoFocus: true,
                                           length: 4,
                                           obscureText: true,
                                           animationType: AnimationType.fade,
                                           pinTheme: PinTheme(
                                             activeFillColor: kWhite,
                                             inactiveFillColor: kWhite,
                                             selectedFillColor: kWhite,
                                             activeColor: kGrey1,
                                             inactiveColor: kGrey1,
                                             selectedColor: kGrey1,
                                             shape: PinCodeFieldShape.box,
                                             borderRadius: BorderRadius.circular(5),
                                             fieldHeight: 61.h,
                                             fieldWidth: 51.w,
                                           ),
                                           animationDuration: Duration(milliseconds: 300),
                                           controller: firstPinController,
                                           onCompleted: (v) async{
                                           },
                                           beforeTextPaste: (text) {
                                             print("Allowing to paste $text");
                                             //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                             //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                             return true;
                                           }, appContext: context,
                                         ),
                                       ),
                                     ),
                                     SizedBox(height:47.h),
                                     Align(
                                       alignment: Alignment.center,
                                       child: Container(
                                         height: 50.h,
                                         width: 241.w,
                                         child: ElevatedButton(
                                           style: ElevatedButton.styleFrom(
                                               backgroundColor: kBlue),
                                           onPressed: () async {
                                             Navigator.pop(context);
                                             showDialog(
                                                 barrierDismissible: false,
                                                 context: context, builder: (context){
                                               return AlertDialog(
                                                   contentPadding: EdgeInsets.all(30.w),
                                                   shape:  RoundedRectangleBorder(
                                                       borderRadius: BorderRadius.circular(18)),
                                                   content: Container(
                                                       width: 301.w,
                                                       height:270.h,
                                                       child: Column(
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           mainAxisSize: MainAxisSize.min,
                                                           children: [
                                                             Row(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children: [
                                                                 Text('Confirm New PIN',
                                                                   style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
                                                                 GestureDetector(
                                                                   onTap: ()=>Navigator.pop(context),
                                                                   child: SizedBox(
                                                                       width: 42.w,
                                                                       height: 42.w,
                                                                       child: Image.asset('lib/assets/images/rides/cancel1.png')),
                                                                 )


                                                               ],
                                                             ),
                                                             Align(
                                                               alignment: Alignment.center,
                                                               child: Container(
                                                                 margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
                                                                 height: 61.h,
                                                                 width: 260.w,
                                                                 decoration:  BoxDecoration(
                                                                   borderRadius: BorderRadius.circular(7),),
                                                                 child: PinCodeTextField(
                                                                   showCursor: true,
                                                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                   autoUnfocus: true,
                                                                   autoDisposeControllers: false,
                                                                   keyboardType: TextInputType.number,
                                                                   onChanged: (v){},
                                                                   autoFocus: true,
                                                                   length: 4,
                                                                   obscureText: true,
                                                                   animationType: AnimationType.fade,
                                                                   pinTheme: PinTheme(
                                                                     activeFillColor: kWhite,
                                                                     inactiveFillColor: kWhite,
                                                                     selectedFillColor: kWhite,
                                                                     activeColor: kGrey1,
                                                                     inactiveColor: kGrey1,
                                                                     selectedColor: kGrey1,
                                                                     shape: PinCodeFieldShape.box,
                                                                     borderRadius: BorderRadius.circular(5),
                                                                     fieldHeight: 61.h,
                                                                     fieldWidth: 51.w,
                                                                   ),
                                                                   animationDuration: Duration(milliseconds: 300),
                                                                   controller: secondPinController,
                                                                   onCompleted: (v) async{
                                                                   },
                                                                   beforeTextPaste: (text) {
                                                                     print("Allowing to paste $text");
                                                                     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                                     //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                                     return true;
                                                                   }, appContext: context,
                                                                 ),
                                                               ),
                                                             ),
                                                             SizedBox(height:47.h),
                                                             Align(
                                                               alignment: Alignment.center,
                                                               child: Container(
                                                                 height: 50.h,
                                                                 width: 241.w,
                                                                 child: ElevatedButton(
                                                                   style: ElevatedButton.styleFrom(
                                                                       backgroundColor: kBlue),
                                                                   onPressed: () async {
                                                                     final prefs = await SharedPreferences.getInstance();
                                                                    try{
                                                                      if(firstPinController.text == secondPinController.text){
                                                                        spinner(context);
                                                                        final res = await resetPin(secondPinController.text);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        if(res['statusCode'] == 200){
                                                                          prefs.setString('mypin',secondPinController.text);
                                                                          showSnackBar(context, 'Pin changed');
                                                                        }
                                                                        else{
                                                                          showSnackBar(context,res['errorMessage']);
                                                                        }

                                                                      }
                                                                      else{
                                                                        showSnackBar(context, 'New pin mismatch!');
                                                                      }
                                                                    }
                                                                    catch(e){
                                                                      Navigator.pop(context);
                                                                      showSnackBar(context, 'Error Occurred');
                                                                      print(e.toString());
                                                                    }
                                                                   },
                                                                   child: Text('Reset Pin',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                                                                 ),
                                                               ),
                                                             )
                                                           ]
                                                       )));});
                                           },
                                           child: Text('Confirm Pin',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                                         ),
                                       ),
                                     )
                                   ]
                               ),
                             ));});
                         }
                       },
                       child: Text('Confirm',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                     ),
                   ),
                 )
               ],
             ),
           ),
         );});
       break;
       case 1:  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
           UserSelector()));
       break;
       case 2: await picturing(context);
       break;
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height:77.h),
          backButton(context),
            SizedBox(height:20.h),
            Text('Settings',style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w600),),
            SizedBox(height:20.h),
            Divider(color: kBlack1),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 15.sp,),
                  onTap: (){
                    settingsSelect(index,context);
                  },
                  title: Text( settingsItem[index],style: TextStyle(fontSize: 20.sp)),

                );
              },
              separatorBuilder: (BuildContext context, int index) { return Divider(color: kBlack1,); },
              itemCount: settingsItem.length),
            Divider(color: kBlack1),
        ],),
      ),
    );
  }
}
