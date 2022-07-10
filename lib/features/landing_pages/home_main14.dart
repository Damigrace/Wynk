import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_page_welcome.dart';

class HomeMain14 extends StatefulWidget {
  const HomeMain14({Key? key}) : super(key: key);

  @override
  State<HomeMain14> createState() => _HomeMain14State();
}

class _HomeMain14State extends State<HomeMain14> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3)  , ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
        const HomePageWelcome()
    )));
  }
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3));
    return Scaffold(
      body: SafeArea(
        child:Padding(
          padding:  EdgeInsets.only(top: 15.h),
          child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset('lib/assets/images/wynkimage.png',width: 63.w,height: 42.h,)),
        ) ,
      ),
    );
  }
}
