import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utilities/widgets.dart';
class RidesList extends StatelessWidget {
   RidesList({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer:  Drawer(elevation: 0,
          backgroundColor: Colors.white,
          width: 250.w,
          child: DrawerWidget(),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 18.w,right: 18.w,top: 59.h,bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(context),
                  GestureDetector(
                    onTap:  () { _key.currentState!.openDrawer();},
                    child: Image.asset('lib/assets/menu.webp'),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              Text('Ride History',style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600),),
              SizedBox(height: 10.h,),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: context.read<FirstData>().rides,),
              ),
            ],
          ),
        ));
  }
}
