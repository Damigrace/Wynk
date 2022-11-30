import 'dart:async';

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
import '../../utilities/widgets.dart';
class CaptainTripSummary extends StatefulWidget {
  const CaptainTripSummary({Key? key}) : super(key: key);

  @override
  _CaptainTripSummaryState createState() => _CaptainTripSummaryState();
}

class _CaptainTripSummaryState extends State<CaptainTripSummary> {
  double? devWidth;
  double? devHeigth;
  double? rate = 0;
  num? fair = 2100;
  bool isPaid = false;
  Timer? timer;
  final balanceFormatter = NumberFormat("#,##0", "en_NG");
  checkPaymentStat()async{
    dynamic val = await rideStatus(rideCode: context.read<RideDetails>().rideCode!);
    switch(val['status_code']){
      case '1':
        {
          timer?.cancel();
          setState(() {
            isPaid = true;
          });
        }
        break;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 5), (_) async {
      checkPaymentStat();
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    devWidth=MediaQuery.of(context).size.width;
    devHeigth=MediaQuery.of(context).size.height;
    return context.read<RideDetails>().paymentMode == 'wallet'?FractionallySizedBox(
      heightFactor: 716.h/MediaQuery.of(context).size.height,
      child:
      isPaid == true?Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width:devWidth ,
        decoration: const BoxDecoration(
            color: Color(0xff7573B6),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child:  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 37.h,),
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
                        child: GestureDetector(
                            onTap: ()async{
                              spinner(context);
                              final pos = await determinePosition(context);
                              final res = await updateRideInfo(
                                wynkid: context.read<FirstData>().uniqueId!,
                                code: context.read<RideDetails>().rideCode!,
                                rideStat: 5,
                                currentPos: LatLng(pos.latitude, pos.longitude),);
                              showToast(res!['errorMessage'].toString());
                              refresh(context);

                              Navigator.pushNamedAndRemoveUntil(context, '/CaptainOnline', ModalRoute.withName('/CaptainHome'));
                            },
                            child: Image.asset('lib/assets/images/rides/cancel1.png',color: Colors.white,)),
                      ),
                    ),
                  ),
                ],),
              SizedBox(height: 20.h,),
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
              SizedBox(height: 19.h,),
              Text('₦${context.read<RideDetails>().fair}',style: TextStyle(fontSize:50.sp ,color: Colors.white),),
              SizedBox(height: 82.h,),
              Text('Please rate your rider',style: TextStyle(fontSize:15.sp ,color: Colors.white)),
              SizedBox(height: 19.h,),
              RatingBar.builder(
                itemSize: 35.w,
                itemBuilder: (context,_){return
                  const Icon(Icons.star,color: kYellow,);},
                onRatingUpdate: (double value) {
                  print(value);
                  rate = value;
                },),
              SizedBox(height: 27.h,),
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
                            showDialog(context: context, builder: (context){
                              return SpinKitCircle(color: kYellow,);
                            });
                            final pos = await determinePosition(context);
                            final res = await updateRideInfo(
                              wynkid: context.read<FirstData>().uniqueId!,
                              code: context.read<RideDetails>().rideCode!,
                              rideStat: 5,
                              currentPos: LatLng(pos.latitude, pos.longitude),);
                            final userDet =await getCapDetails(context.read<FirstData>().uniqueId);
                            context.read<FirstData>().saveVaultB(userDet['actualBalance'].toString());
                            context.read<FirstData>().saveTodayEarning(userDet['todayearning'].toString());
                            context.read<FirstData>().saveAverageRating(userDet['averagerating'].toString());
                            context.read<FirstData>().saveTodayTrip(userDet['todaytrip'].toString());
                            accountBalCont.text =  '₦${userDet['currentBalance'].toString()}';
                            rideRating(rideCode: context.read<RideDetails>().rideCode!, star: rate!,
                                comment: captainCommentCont.text,wynikd: context.read<FirstData>().uniqueId!);
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                            refresh(context);
                            captainCommentCont.clear();
                            Navigator.pushNamedAndRemoveUntil(context, '/CaptainOnline', ModalRoute.withName('/CaptainHome'));
                            // Navigator.popUntil(context,ModalRoute.withName('/CaptainOnline'));
                          },
                          child: Image.asset('lib/assets/images/riderSend.png',width: 33.w,height: 33.w,)))
                ],
              ),
              SizedBox(height: 10.h,)
            ],),
        ),)
          :Center(child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitSpinningLines(color: kYellow),
            SizedBox(height: 25.h,),
            Text('Dear Captain, Kindly exercise patience while we confirm if ride payment is successful.',
              style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600, color: Colors.black),
              textAlign: TextAlign.center,),
            SizedBox(height: 20.h,),
            TextButton(
              onPressed: ()async{
                spinner(context);
                final pos = await determinePosition(context);
                 updateRideInfo(
                    wynkid: context.read<FirstData>().uniqueId!,
                code: context.read<RideDetails>().rideCode!,
                rideStat: 1,
                currentPos: LatLng(pos.latitude, pos.longitude),);
                Navigator.pushNamedAndRemoveUntil(context, '/CaptainOnline', ModalRoute.withName('/CaptainHome'));
              },
              child: Text('Customer has paid'),
            )
          ],
        ),
      )),):

      Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width:devWidth ,
        decoration: const BoxDecoration(
            color: Color(0xff7573B6),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child:  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 37.h,),
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
              SizedBox(height: 20.h,),
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
              SizedBox(height: 19.h,),
              Text('₦${context.read<RideDetails>().fair}',style: TextStyle(fontSize:50.sp ,color: Colors.white),),
              SizedBox(height: 82.h,),
              Text('Please rate your rider',style: TextStyle(fontSize:15.sp ,color: Colors.white)),
              SizedBox(height: 19.h,),
              RatingBar.builder(
                itemSize: 35.w,
                itemBuilder: (context,_){return
                const Icon(Icons.star,color: kYellow,);},
                onRatingUpdate: (double value) {
                  print(value);
                  rate = value;
                  },),
              SizedBox(height: 27.h,),
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
                          final userDet =await getCapDetails(context.read<FirstData>().uniqueId);
                          context.read<FirstData>().saveVaultB(userDet['actualBalance'].toString());
                          context.read<FirstData>().saveTodayEarning(userDet['todayearning'].toString());
                          context.read<FirstData>().saveAverageRating(userDet['averagerating'].toString());
                          context.read<FirstData>().saveTodayTrip(userDet['todaytrip'].toString());
                          accountBalCont.text =  '₦${userDet['actualBalance'].toString()}';
                          rideRating(rideCode: context.read<RideDetails>().rideCode!, star: rate!,
                              comment: captainCommentCont.text,wynikd: context.read<FirstData>().uniqueId!);
                         // Navigator.pop(context);
                         // Navigator.pop(context);
                          captainCommentCont.clear();
                          Navigator.pushNamedAndRemoveUntil(context, '/CaptainOnline', ModalRoute.withName('/CaptainHome'));
                         // Navigator.popUntil(context,ModalRoute.withName('/CaptainOnline'));
                        },
                          child: Image.asset('lib/assets/images/riderSend.png',width: 33.w,height: 33.w,)))
                ],
              ),
              SizedBox(height: 10.h,)
            ],),
        ),);

  }
}
