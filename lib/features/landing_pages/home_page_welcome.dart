import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_main17.dart';

class HomePageWelcome extends StatefulWidget {
  const HomePageWelcome({Key? key}) : super(key: key);

  @override
  State<HomePageWelcome> createState() => _HomePageWelcomeState();
}

class _HomePageWelcomeState extends State<HomePageWelcome> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3)  , ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
        const HomeMain17()
    )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Padding(
              padding:  EdgeInsets.only(top: 15.h,bottom: 235.h),
              child: Image.asset('lib/assets/images/wynkimage.png',height: 42.h,width: 63.w,),
            ),
              Hero(
                  tag: 'HeroId',
                  child: Text('Hello Adeola!',style: TextStyle(fontSize: 42.sp,fontWeight: FontWeight.w500),)) //Name will be replaced by actual user name.
          ],),
        ),
      ),
    );
  }
}
