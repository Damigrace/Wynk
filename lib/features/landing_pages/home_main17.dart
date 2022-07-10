import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../setups/vault_welcome.dart';

class HomeMain17 extends StatefulWidget {
  const HomeMain17({Key? key}) : super(key: key);

  @override
  State<HomeMain17> createState() => _HomeMain17State();
}

class _HomeMain17State extends State<HomeMain17> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3)  , ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
        const VaultWelcome()
    )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Padding(
          padding:  EdgeInsets.only(top: 15.h),
          child: Align(
              alignment: Alignment.topCenter,
              child: Hero(
                  tag: 'HeroId',
                  child: Text('Hello Adeola!',style: TextStyle(fontSize: 23.sp,fontWeight: FontWeight.w500),))
        ) ,
      ),
    ));
  }
}
