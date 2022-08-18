import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/login_feature/another_user_login.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/constants/colors.dart';

import '../login_feature/login_page.dart';
import '../registration_feature/register_page.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async{
          print('now popping');
          return Navigator.maybePop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 305.h),
                    child: Image.asset('lib/assets/images/wynkimage.png',width: 230.w,height: 142.h,),
                  ),
                  Text('Rides. Payments. Lifestyle',style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: kLightPurple,
                      fontSize: 20.sp
                  ),),
                  Padding(
                    padding:  EdgeInsets.only(top: 268.h),
                    child: Row(
                      children: [
                        Expanded(child: SizedBox(
                          height: 51.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary:kBlue
                            ),
                            onPressed: ()async{
                              final prefs = await SharedPreferences.getInstance();
                              context.read<FirstData>().getUserP(prefs.getString('userPic'));
                              context.read<FirstData>().getUsername(prefs.getString('firstname'));
                              if(prefs.getString('Origwynkid') == null){
                                Get.to(()=>
                                const AnotherUserLogin(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
                              }
                              else {
                                Get.to(() => const LoginPage(),
                                    transition: Transition.downToUp,
                                    duration: const Duration(seconds: 1));
                              }
                            },
                            child: Text('Login',style: TextStyle(fontSize: 15.sp),),
                          ),
                        )),
                        SizedBox(width: 9.w,),
                        Expanded(child: SizedBox(
                          height: 51.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kYellow
                            ),
                            onPressed: ()async{
                              Get.to(()=>
                              const  RegisterPage(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
                            },
                            child: Text('Register',style: TextStyle(fontSize: 15.sp),),
                          ),
                        ))
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
