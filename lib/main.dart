import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:untitled/features/landing_pages/home_main.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/landing_pages/home_main17.dart';
import 'package:untitled/features/landing_pages/home_page_welcome.dart';
import 'package:untitled/features/landing_pages/ride_home5.dart';
import 'package:untitled/features/login_feature/another_user_login.dart';
import 'package:untitled/features/login_feature/login_page.dart';
import 'package:untitled/features/registration_feature/confirm_pin.dart';
import 'package:untitled/features/registration_feature/create_pin.dart';
import 'package:untitled/features/registration_feature/patron_captain_signup.dart';
import 'package:untitled/features/registration_feature/register_page.dart';
import 'package:untitled/features/registration_feature/sign_up.dart';
import 'package:untitled/features/registration_feature/sign_up_personal_details.dart';
import 'package:untitled/features/registration_feature/signup_camera_permission.dart';
import 'package:untitled/features/setups/create_transaction_pin.dart';
import 'package:untitled/features/setups/reset%20password.dart';
import 'package:untitled/features/setups/reset_pin.dart';
import 'package:untitled/features/setups/vault_welcome.dart';
import 'package:untitled/features/verification_feature/confirm_transaction_pin.dart';
import 'package:untitled/features/verification_feature/verification.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/widgets.dart';
import 'features/ride/ride_home.dart';
import 'features/landing_pages/welcome_page.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirstData()),
      ],
      child:  ScreenUtilInit(
        designSize: const Size(390,844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MyApp();
        },

      )
    ),
  );
}
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: ThemeData(primaryColor: kBlue),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}

class FirstData with ChangeNotifier{
  List<ChatTile> messages = [ChatTile(text: 'You are welcome', color: Colors.green, time: 'Just now')];
  LatLngBounds? latLngBounds;
  double? lat;
  double? long;
  String? userP;
  String? uniqueId;
  String? otpNumFromServer;
  String? userNumber;
   bool? openCamera;
   File? providerImage;
   String? userImgUrl;
   String? userVerEndpoint;
   String? UserSelectedId;
   String? username;
   bool? isReg;
   bool? isCaptainReg;
  bool? showTopbar = true;
  bool? showBackbutton = false;
  addChat(ChatTile chat){
    messages?.add(chat);
    notifyListeners();
  }
  checkCapRegStat(bool isCapReg){
    isCaptainReg=isCapReg;
    notifyListeners();
  }
  topBar(bool topBarVisibility){
    showTopbar=topBarVisibility;
    notifyListeners();
  }
  backButton(bool backButVis){
    showBackbutton = backButVis;
    notifyListeners();
  }
   saveCurrentLocat(double lt, double lng){
     lat=lt;
     long=lng;
     notifyListeners();
   }
  saveLatLngBounds(LatLngBounds llb){
    latLngBounds=llb;
    notifyListeners();
  }

  checkUserRegStat(bool isreg){
    isReg=isReg;
    notifyListeners();
  }
   getUserP(String? incomingP){
     userP=incomingP;
     notifyListeners();
   }
  getUsername(String? incomingN){
    username=incomingN;
    notifyListeners();
  }

  getSelectedId(String? selectedId){
    UserSelectedId=selectedId;
    notifyListeners();
  }
   getUserVerEndpoint(String? userEndPBId){
     userVerEndpoint=userEndPBId;
     notifyListeners();
   }
  getUserImgUrl(String? userImgUrInput){
    userImgUrl=userImgUrInput;
    notifyListeners();
  }
  getOtpNumberFromServer(String? otp){
    otpNumFromServer=otp;
    notifyListeners();
  }
  getUniqueId(String? uniqueIdIn){
    uniqueId=uniqueIdIn;
    notifyListeners();
  }
   getUserNumber(String? user){
     userNumber=user;
     notifyListeners();
   }
   yesCamera(){
       openCamera=true;
       notifyListeners();

}
  noCamera(){
    openCamera=false;
    notifyListeners();}
   imageGotten(File? file){
     providerImage=file;
     notifyListeners();
   }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3)  , ()async{
      final prefs = await SharedPreferences.getInstance();
      context.read<FirstData>().getUserP(prefs.getString('userPic'));
      context.read<FirstData>().getUsername(prefs.getString('firstname'));
      if(prefs.getString('Origwynkid') == null){
        FocusScope.of(context).nearestScope;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AnotherUserLogin()));
      }
      else {
        FocusScope.of(context).nearestScope;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
      }

       });
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      height: double.infinity,
        width: double.infinity,
      color: Colors.white,
      child: Image.asset(
        'lib/assets/images/wynkimage.png'
      ),
    );
  }
}

// child:
// ScreenUtilInit(
// designSize: const Size(390,844),
// minTextAdapt: true,
// splitScreenMode: true,
// builder: (context, child){
// return  HomeMain14();
// },
// )
// ,
// providers: [
// ChangeNotifierProvider(create: (_)=>FirstData())
// ]);