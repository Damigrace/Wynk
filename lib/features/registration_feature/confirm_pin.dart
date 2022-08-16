import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/registration_feature/signup_camera_permission.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
import 'package:untitled/services.dart';
import 'dart:io';

import '../../main.dart';
String? userConfirmTpin;
class ConfirmTPin extends StatefulWidget {

  const ConfirmTPin({Key? key}) : super(key: key);

  @override
  State<ConfirmTPin> createState() => _ConfirmTPinState();
}

class _ConfirmTPinState extends State<ConfirmTPin> {
  File? imageFile;
  userUmageAsString()async{
    File? uImage=context.read<FirstData>().providerImage;
    final bytes = await File(uImage!.path).readAsBytes();
    String userImg64 = base64Encode(bytes);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userPic', userImg64);
    print(userImg64);
    return userImg64;
  }
  Future picturing(BuildContext context)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mypin', confirmTPinController.text);
    await saveUserPin(context);
    await camPermission(context);
    bool checkCameraPermission=Provider.of<FirstData>(context, listen: false).openCamera!;
    if(checkCameraPermission==true){
      await getPicture();
      await getUserRegisteredDetails(wynkId: context.read<FirstData>().uniqueId.toString());
      String user64Img= await userUmageAsString();
      context.read<FirstData>().getUserImgUrl(user64Img);
      setState(() {
        showSpinner=false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeMain14()));

    }
  }
  getPicture()async{
    XFile? pickedFile=await ImagePicker().pickImage(
        source: ImageSource.camera);
    if(pickedFile != null){
      imageFile=File(pickedFile.path);
      context.read<FirstData>().imageGotten(imageFile);
      setState(() {
        showSpinner=true;
      });
    }
  }

  Future  camPermission(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('“Wynk Lifestyle App” Would Like To Access Your Camera',style: TextStyle(fontSize: 17.sp),),
        content: const Text('A picture’s worth a thousand words!'),
        actions: [
          TextButton(onPressed: ()async{Navigator.pop(context);await context.read<FirstData>().noCamera();}, child: Text('Don\'t Allow')),
          TextButton(onPressed: ()async{
            print('camera permission button pressed');
            await context.read<FirstData>().yesCamera();
            print('Can use camera');
            Navigator.pop(context);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeMain14()));
          }, child: Text('Ok',textAlign: TextAlign.end,))
        ],
      );

    });
  }
  bool showSpinner=false;
  showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall:showSpinner ,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: backButton(context),
                ),
                Text('Confirm Your Pin',style: kTextStyle1),
                Text('Keep this number safe, its how you will authorize transactions  ',style: kTextStyle5),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin:  EdgeInsets.only(top: 71.h,),
                    height: 61.h,
                    width: 260.w,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(7),),
                    child: PinCodeTextField(
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
                      controller: confirmTPinController,
                      onCompleted: (v) {
                        userConfirmTpin=v;
                        print(userConfirmTpin);
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
                Container(
                  margin:  EdgeInsets.only(top: 90.h,),
                  height: 51.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kBlue
                    ),
                    onPressed: () async {
                      context.read<FirstData>().checkUserRegStat(true);
                      setState(() {
                        showSpinner=true;
                      });
                      if(confirmTPinController.text==transactionPinController.text){
                    await picturing(context);
                      }
                      else if(confirmTPinController.text!=transactionPinController.text){
                        showToast('Pin Code Mismatch. Try Again');
                        setState(() {
                          showSpinner=false;
                        });
                      }
                    },
                    child: Text('Submit',style:kTextStyle2,),
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
