import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/utilities/constants/colors.dart';

import '../registration_feature/register_page.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
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
                    child: Image.asset('lib/assets/images/image (1).png',width: 230.w,height: 142,),
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
                            onPressed: (){
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
                            onPressed: (){Get.to(()=>
                              const  RegisterPage(),transition: Transition.downToUp,duration: const Duration(seconds: 2));
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
