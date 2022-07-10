import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:untitled/features/landing_pages/home_main.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/landing_pages/home_main17.dart';
import 'package:untitled/features/landing_pages/home_page_welcome.dart';
import 'package:untitled/features/landing_pages/ride_home5.dart';
import 'package:untitled/features/registration_feature/register_page.dart';
import 'package:untitled/features/registration_feature/sign_up.dart';
import 'package:untitled/features/registration_feature/sign_up_personal_details.dart';
import 'package:untitled/features/setups/create_transaction_pin.dart';
import 'package:untitled/features/setups/reset%20password.dart';
import 'package:untitled/features/setups/vault_welcome.dart';
import 'package:untitled/features/verification_feature/confirm_transaction_pin.dart';
import 'package:untitled/features/verification_feature/verification.dart';
import 'features/landing_pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390,844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child){
        return  const MaterialApp(
          debugShowCheckedModeBanner: false,
            home: SplashScreen(),
        );
      },
    );
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
    Timer(const Duration(seconds: 3)  , ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
    const WelcomePage()
    )));
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
