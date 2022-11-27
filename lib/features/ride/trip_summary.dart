import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
class TripSummary extends StatefulWidget {
  const TripSummary({Key? key}) : super(key: key);

  @override
  _TripSummaryState createState() => _TripSummaryState();
}

class _TripSummaryState extends State<TripSummary> {
  double? devWidth;
  double? devHeigth;
  num? fair = 2100;
  final balanceFormatter = NumberFormat("#,##0", "en_NG");
  @override
  Widget build(BuildContext context) {
    devWidth=MediaQuery.of(context).size.width;
    devHeigth=MediaQuery.of(context).size.height;
    return FractionallySizedBox(
      heightFactor: 716.h/MediaQuery.of(context).size.height,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width:devWidth ,
        decoration: const BoxDecoration(
            color: Color(0xff7573B6),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child:  SingleChildScrollView(
          child: Column(
            children: [
              Flexible(child: SizedBox(height: 37.h,)),
              Row(
                children: [
                  SizedBox(width: 111.w,),
                  Text('Trip Summary',style: TextStyle(fontSize: 20.sp,color: Colors.white),),
                  Flexible(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin:  EdgeInsets.only(top: 4.h,left: 66.w,right: 25.w),
                        width: 42.w,
                        height: 42.w,
                        child: Image.asset('lib/assets/images/rides/cancel1.png',color: Colors.white,),
                      ),
                    ),
                  ),
                ],),
              Flexible(child: SizedBox(height: 122.h,)),
              Container(
                width: 70.w,
                height: 70.w,
                margin: EdgeInsets.only(bottom: 26.h),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: Image.asset('lib/assets/images/tripSummaryMark.png')),),),
               Text('RIDE COMPLETED',style: TextStyle(fontSize:12.sp ,color: Colors.white)),
              Flexible(child: SizedBox(height: 19.h,)),
              Text('₦${context.read<RideDetails>().fair}',style: TextStyle(fontSize:60.sp ,color: Colors.white),),
              Flexible(child: SizedBox(height: 82.h,)),
              Text('Please rate your rider',style: TextStyle(fontSize:15.sp ,color: Colors.white)),
              SizedBox(height: 19.h,),
              Flexible(
                child: RatingBar.builder(
                  itemSize: 35.w,
                  itemBuilder: (context,_){return
                  const Icon(Icons.star,color: kYellow,);},
                  onRatingUpdate: (double value) { print(value); },),
              ),
              Flexible(child: SizedBox(height: 27.h,)),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 17.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: 293.w,
                    height: 138.h,
                    child: TextField(
                      maxLines: null,
                      cursorColor: kYellow,
                      controller: captainCommentCont,
                      style: TextStyle(fontSize: 13.sp),
                      decoration: InputDecoration.collapsed(
                          hintText: 'Tell us what went wrong'),
                    ),
                  ),
                  Positioned(
                      bottom: 14.h,
                      right: 12.w,
                      child: GestureDetector(
                        onTap: ()async{
                          captainCommentCont.clear();
                          showDialog(context: context, builder: (context){
                            return SpinKitCircle(color: kYellow,);
                          });
                          final pos = await determinePosition(context);
                          final res = await updateRideInfo(
                              wynkid: context.read<FirstData>().uniqueId!,
                              code: context.read<RideDetails>().rideCode!,
                              rideStat: 5,
                              currentPos: LatLng(pos.latitude, pos.longitude),);
                          showToast(res!['errorMessage'].toString());
                          Navigator.pop(context);
                          Navigator.popUntil(context,ModalRoute.withName('/CaptainHome'));
                        },
                          child: Image.asset('lib/assets/images/riderSend.png',width: 33.w,height: 33.w,)))
                ],
              ),
              SizedBox(height: 10.h,)
            ],),
        ),),
    );
  }
}
