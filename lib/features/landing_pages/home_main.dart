import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'package:untitled/utilities/constants/textstyles.dart';
import 'package:untitled/utilities/widgets.dart';
class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  TextEditingController vaultBalanceController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:   EdgeInsets.only(top:15.h,left:10.w ,right: 25.w),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(children: [
                const UserTopBar(),
                SizedBox(height: 15.h,),
                SizedBox(
                    height: 61.h,
                    width: double.infinity,
                    child:Column(
                      children: [
                        SizedBox(height: 25.h),
                        Padding(
                          padding:  EdgeInsets.only(left: 18.w),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.eye_slash_fill),
                              SizedBox(width: 10.w,),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  style: kTextStyle5,
                                  decoration:  const InputDecoration.collapsed(
                                      hintText: 'Vault Balance',hintStyle: TextStyle(color: kBlack1//B
                                  )),
                                  controller: vaultBalanceController,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ],),
            ),
          ),
        ),
      ),
    );
  }
}