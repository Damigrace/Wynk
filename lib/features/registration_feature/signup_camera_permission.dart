import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/utilities/widgets.dart';
import 'dart:io';
import '../../main.dart';
import 'image.dart';
class CamPerm extends StatefulWidget {
  const CamPerm({Key? key}) : super(key: key);

  @override
  State<CamPerm> createState() => _CamPermState();
}

class _CamPermState extends State<CamPerm> {
  bool? hasCamPerm=false;
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
  userUmageAsString()async{
    File? uImage=context.read<FirstData>().providerImage;
    final bytes = await File(uImage!.path).readAsBytes();
    String userImg64 = base64Encode(bytes);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userPic', userImg64);
    print(userImg64);
    return userImg64;
  }
  File? imageFile;
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
  bool isPerAsk=false;
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), ()async{
      bool checkCameraPermission=Provider.of<FirstData>(context, listen: false).openCamera!;

      if(checkCameraPermission==true){
        await getPicture();
        checkCameraPermission=false;
        String user64Img= await userUmageAsString();
        context.read<FirstData>().getUserImgUrl(user64Img);
        setState(() {
          showSpinner=false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeMain14()));

      }
      else{Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeMain14()));
      }
    });

    return Scaffold(body: SafeArea(
      child: Padding(
        padding:  EdgeInsets.only(left: 36.w,top: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: backButton(context),
          ),
          SizedBox(height: 20.h,),
          Align(
              alignment: Alignment.center,
              child: Image.asset('lib/assets/images/wynkimage.png',width: 201.w,height: 135.h,))
        ],),
      ),
    ),);
  }
}



