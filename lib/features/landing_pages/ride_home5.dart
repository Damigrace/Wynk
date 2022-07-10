
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
class RideHome5 extends StatelessWidget {
  const RideHome5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/Map.jpg',),
          fit: BoxFit.contain,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 9.h),
                    child: ListTile(
                        leading: CircleAvatar(
                          child: ClipRect(child: Image.asset('lib/assets/images/wynkimage.png',scale: 7,)),
                        ),
                        title: Text('Cpt. Adeola!',style: TextStyle(fontSize: 23.sp),),
                        trailing:Icon(Icons.menu,size: 30.sp,)
                    ),
                  ),
                  SizedBox(height: 672.h,),
                  Padding(
                    padding:  EdgeInsets.only(top: 0.h),
                    child: SizedBox(
                      height: 60.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: kBlue
                        ),
                        onPressed: (){
                        },
                        child: Text('GO ONLINE ',style: TextStyle(fontSize: 15.sp),),
                      ),
                    ),
                  ),
                ],),
            ),
          ),
        ),
      ),
    );
  }
}