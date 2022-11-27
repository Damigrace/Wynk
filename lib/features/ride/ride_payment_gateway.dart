import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../local_notif.dart';
class RidePaymentGateway extends StatelessWidget {
  RidePaymentGateway({Key? key}) : super(key: key);
  wynkPayForRide(BuildContext context)async{
    final res = await ridePayment(
        captainWynkId:  context.read<CaptainDetails>().capId!,
        rideCode: context.read<CaptainDetails>().rideCode!,
        paymentMeans: context.read<FirstData>().paymentMeans
    );
    print('save success 1');
    if(res['statusCode'] == 200){
      final pos = await determinePosition(context);
      context.read<FirstData>().saveActiveRide(false);
       updateRideInfo(
          wynkid: context.read<FirstData>().uniqueId!,
          code: context.read<CaptainDetails>().rideCode!,
          currentPos: LatLng(pos.latitude, pos.longitude),
          rideStat: 1);
     await context.read<CaptainDetails>().saveFairDetails(res['base_fare']??'--', res['time']??'--', res['convinience_fee']??'--', res['road_maintenance']??'--', res['distance']??'--', res['total']??'--');
    }
    print('save success 2');
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future:wynkPayForRide(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData){
              print('has data');
             if(snapshot.data['statusCode'] == 200){
               print('payed');
               Future.delayed(Duration(seconds: 1),(){
                 print('navigating');
                 NotificationService.showNotif('Wynk', 'Ride has ended. Kindly leave a comment below. Thank you.');
                 Navigator.pushReplacementNamed(
                     context,'/PatronTripEnded');

               });
                  return Center(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Stack(children: [
                         Container(
                           width: 177.w,
                           height: 177.h,
                         ),
                         Container(
                           decoration: BoxDecoration(
                               color: Colors.black12,
                               borderRadius: BorderRadius.circular(9)
                           ),
                           width: 150.w,
                           height: 150.w,
                         ),
                         Positioned(
                             bottom: 0,
                             right: 0,
                             child: SizedBox(
                                 width: 57.w,
                                 height: 57.w,
                                 child: Image.asset('lib/assets/images/airtime_logo/payment_success.png'))),
                       ],),
                       SizedBox(height: 27.h,),
                       context.read<FirstData>().paymentMeans! == 'cash'?
                       Text('Your ride has ended',
                         style: TextStyle(fontSize: 26.sp),
                         textAlign: TextAlign.center,):
                       Text('Your ride payment was \nsuccessfull!',
                         style: TextStyle(fontSize: 26.sp),
                         textAlign: TextAlign.center,),
                       SizedBox(height: 54.h,),
                       // GestureDetector(
                       //   onTap: (){
                       //     Navigator.pushReplacementNamed(
                       //         context,'/RideEnded');
                       //   },
                       //   child: Container(
                       //
                       //     width: 318.w,
                       //     height: 50.h,
                       //     decoration: BoxDecoration(
                       //       color: kBlue,
                       //       borderRadius: BorderRadius.circular(7),
                       //     ),
                       //     child: Center(
                       //       child: Text('Get',
                       //         style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                       //     ),
                       //   ),),
                       // GestureDetector(
                       //   onTap:(){
                       //     Navigator.pop(context);
                       //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                       //         HomeMain14()), (Route<dynamic> route) => false);
                       //   } ,
                       //   child: Container(
                       //     width: 318.w,
                       //     height: 50.h,
                       //     margin: EdgeInsets.only(top:15.h),
                       //     decoration: BoxDecoration(
                       //         color: Colors.white,
                       //         borderRadius: BorderRadius.circular(7),
                       //         border: Border.all(color: Colors.black)
                       //     ),
                       //     child: Center(
                       //       child: Text('Go Home',
                       //           style: TextStyle(fontSize: 15.sp)),
                       //     ),
                       //   ),),
                     ],)
               );
             }
             else{
               return Center(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Stack(children: [
                         Container(
                           width: 177.w,
                           height: 177.h,
                         ),
                         Container(
                           decoration: BoxDecoration(
                               color: Colors.black12,
                               borderRadius: BorderRadius.circular(9)
                           ),
                           width: 150.w,
                           height: 150.w,
                         ),
                         Positioned(
                             bottom: 0,
                             right: 0,
                             child: SizedBox(
                                 width: 57.w,
                                 height: 57.w,
                                 child: Image.asset('lib/assets/images/airtime_logo/payment_success.png'))),
                       ],),
                       SizedBox(height: 27.h,),
                       Text('Your payment was \n not successful!',
                         style: TextStyle(fontSize: 26.sp),
                         textAlign: TextAlign.center,),
                       SizedBox(height: 54.h,),
                       GestureDetector(
                         onTap: (){
                           Navigator.pushReplacementNamed(
                               context,'/RidePaymentGateway');
                         },
                         child: Container(

                           width: 318.w,
                           height: 50.h,
                           decoration: BoxDecoration(
                             color: kBlue,
                             borderRadius: BorderRadius.circular(7),
                           ),
                           child: Center(
                             child: Text('Retry payment',
                               style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                           ),
                         ),),
                       // GestureDetector(
                       //   onTap:(){
                       //     Navigator.pop(context);
                       //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                       //         HomeMain14()), (Route<dynamic> route) => false);
                       //   } ,
                       //   child: Container(
                       //     width: 318.w,
                       //     height: 50.h,
                       //     margin: EdgeInsets.only(top:15.h),
                       //     decoration: BoxDecoration(
                       //         color: Colors.white,
                       //         borderRadius: BorderRadius.circular(7),
                       //         border: Border.all(color: Colors.black)
                       //     ),
                       //     child: Center(
                       //       child: Text('Go Home',
                       //           style: TextStyle(fontSize: 15.sp)),
                       //     ),
                       //   ),),
                       SizedBox(height: 15.h),
                       GestureDetector(
                         onTap: (){
                           Navigator.pushReplacementNamed(
                               context,'/TripEnded');
                         },
                         child: Container(

                           width: 318.w,
                           height: 50.h,
                           decoration: BoxDecoration(
                             color: kBlue,
                             borderRadius: BorderRadius.circular(7),
                           ),
                           child: Center(
                             child: Text('Pay with cash',
                               style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                           ),
                         ),),
                     ],)
               );
             }
             // NotificationSwidervice.showNotif('Wynk', 'Ride has ended. Kindly leave a comment below. Thank you.');
            }

            return Center(child: Container(
              width: 230,height: 100,
              child: Column(
                children: [
              context.read<FirstData>().paymentMeans! == 'cash'?
              Text('Ending Ride…',textAlign: TextAlign.center,):
              Text('Routing to Payment Gateway.\nPlease wait…',textAlign: TextAlign.center,),
                  SizedBox(height: 10.h,),
                  SpinKitCircle(color: kYellow,),
                ],
              ),),);
          },)
    );
  }
}