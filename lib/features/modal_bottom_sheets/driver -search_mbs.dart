import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/features/modal_bottom_sheets/driver_found_mbs.dart';
import 'package:untitled/services.dart';

class DriverSearch extends StatelessWidget {
  String? carImage;
  DriverSearch({
    Key? key,
    required this.totalDuration,required this.carImage
  }) : super(key: key);

   String? totalDuration;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: determinePosition(context),

      // lookForCaptain(pickupPos: startPosition!, destPos: endPosition!, wynkid: wynkid!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){

        return DriverFound();
        }
        return Container(
          height: 309.h,
          width:MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
          ),
          padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 15.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:  CrossAxisAlignment.center,
            children: [
              SizedBox(height: 17.h,),
              Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 7.h,),
              SizedBox(height: 33.h,),
              Text('Looking for Captain...',style: TextStyle(fontSize: 18.sp),),
              SizedBox(height: 14.h,),
              Text('Estimated drop-off time is $totalDuration',style: TextStyle(fontSize: 12.sp,color: Color(0xff0f0f0f)),),
              Container(
                  margin: EdgeInsets.only(top: 6.h),
                  width: 209.w,height: 109.h,
                  child: Image.asset(carImage!))
            ],),);
      },
    );
  }
}