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

  int? picUploadMode;
  UserType()async{
    final val = await getUserType();
    String userT = val!['usertype'];

    context.read<FirstData>().saveUserType(userT);
    context.read<FirstData>().saveOriguser(userT);
  }
  getWalletDet()async{
    context.read<WalletDetails>().wallets.clear();
    final res = await walletDetails(context);
    final wallets = res['message']as List;
    for(var wallet in wallets){
      Wallet wal = Wallet(walletName: wallet['walletname'],
          walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
      context.read<WalletDetails>().saveWallet(wal);
    }

  }
  picturing2(BuildContext context)async{
    context.read<FirstData>().saveOriguser('3');
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
                      UserType();
                      getWalletDet();
                      await savePicture(user64Img, prefs.getString('Origwynkid')!);

                      Navigator.push(myC, MaterialPageRoute(builder: (context)=>const HomeMain14()));
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
                      await savePicture(user64Img, prefs.getString('Origwynkid')!);
                      Navigator.push(myC, MaterialPageRoute(builder: (context)=>const HomeMain14()));
                    },
                  )
                ],)
          );
        });

  }
  getPicture()async{
    XFile? pickedFile=await ImagePicker().pickImage(
        source: picUploadMode == 0?ImageSource.camera:ImageSource.gallery);
    if(pickedFile != null){
      imageFile=File(pickedFile.path);
      context.read<FirstData>().imageGotten(imageFile);
    }
  }
  userUmageAsString()async{
    File? uImage=context.read<FirstData>().providerImage;
    final bytes = await File(uImage!.path).readAsBytes();
    String userImg64 = base64Encode(bytes);
    return userImg64;
  }
  Future picturing(BuildContext context)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mypin', confirmTPinController.text);
    await saveUserPin(context);
    Navigator.pop(context);
    await camPermission(context);
    bool checkCameraPermission=Provider.of<FirstData>(context, listen: false).openCamera!;
    if(checkCameraPermission==true){
      await picturing2(context);
      await getUserRegisteredDetails(wynkId: context.read<FirstData>().uniqueId.toString());

    }
  }

  Future  camPermission(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('“Wynk Lifestyle App” Would Like To Access Your Camera and Gallery',style: TextStyle(fontSize: 17.sp),),
        content: const Text('A picture’s worth a thousand words!'),
        actions: [
          TextButton(onPressed: ()async{Navigator.pop(context);await context.read<FirstData>().noCamera();},
              child: Text('Don\'t Allow')),
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
  showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kBlueTint,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
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
                      backgroundColor: kBlue
                  ),
                  onPressed: () async {
                    if(confirmTPinController.text==transactionPinController.text){
                      spinner(context);
                  await picturing(context);
                    }
                    else if(confirmTPinController.text!=transactionPinController.text){
                      showSnackBar(context,'Pin Code Mismatch. Try Again');
                    }
                  },
                  child: Text('Submit',style:kTextStyle2,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
