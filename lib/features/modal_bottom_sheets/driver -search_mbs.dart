import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/features/ride/captain_found.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';

import '../../utilities/constants/colors.dart';
import '../local_notif.dart';

class DriverSearch extends StatefulWidget {
  String? carImage;
  LatLng startPosition;
  LatLng endPosition;
  String? wynkid;
  String? totalDuration;
  DriverSearch({
    Key? key,
    required this.totalDuration,
    required this.carImage,
    required this.endPosition,
    required this.startPosition,
    required this.wynkid,
  }) : super(key: key);

  @override
  State<DriverSearch> createState() => _DriverSearchState();
}

class _DriverSearchState extends State<DriverSearch> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  bool notified1 = false;
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return CaptainSearch(widget.startPosition, widget.endPosition, widget.wynkid,widget.carImage,widget.totalDuration);
  }

   saveDetails(Map<String, dynamic> rideDetails)async{
    await Future.delayed(Duration(seconds: 2));
    final capDet = await getCapDetails(rideDetails['captain_wynkid']);
    context.read<CaptainDetails>().saveCapRating(capDet['averagerating']);
    context.read<CaptainDetails>().saveCapPlate(rideDetails['car_plate_number']);
    context.read<CaptainDetails>().saveCapId(rideDetails['captain_wynkid']);
    context.read<CaptainDetails>().saveRideCode(rideDetails['code']);
    context.read<CaptainDetails>().saveCaptLocation(LatLng(double.parse(rideDetails['lat']), double.parse(rideDetails['long'])));
    context.read<CaptainDetails>().saveCapArrTime(rideDetails['min']);
    context.read<CaptainDetails>().saveCapArrInfo('Captain Arrives in ${context.read<CaptainDetails>().capArrivalTime}');
    context.read<CaptainDetails>().saveCarBrand(rideDetails['brand']);
    context.read<CaptainDetails>().saveCarModel(rideDetails['model']);
    context.read<CaptainDetails>().saveCarColor(rideDetails['color']);
    context.read<CaptainDetails>().savePhone(rideDetails['phone']);
    context.read<CaptainDetails>().saveFair(rideDetails['estimated']);
    context.read<CaptainDetails>().saveCapName(rideDetails['captain_fname']);

    timer = Timer.periodic(Duration(seconds: 10), (_) async {
      print('checking  ride status');
      dynamic val = await rideStatus(rideCode: context.read<CaptainDetails>().rideCode!);
      switch(val['status_code']){

        case '4':
          if(notified1 == false){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  CaptainFound()));
            NotificationService.showNotif('Wynk', 'Captain has accepted your ride request');
            timer?.cancel();
            notified1 = true;
          }
          break;
        case '3':
          {
            Navigator.pop(context);
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                isDismissible: false,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                context: context, builder: (context){
              return DriverSearch(
                totalDuration: context.read<FirstData>().totalDuration,
                carImage: context.read<FirstData>().rideImage,
                wynkid: context.read<FirstData>().uniqueId,
                endPosition:  LatLng(
                    context.read<FirstData>().endPos!.geometry!.location!.lat!,
                    context.read<FirstData>().endPos!.geometry!.location!.lng!),
                startPosition: context.read<FirstData>().patronCurentLocation??
                    LatLng(context.read<FirstData>().startPos!.geometry!.location!.lat!,
                        context.read<FirstData>().startPos!.geometry!.location!.lng!),);
            });
            timer?.cancel();
          }break;
      }
    });


  }
  Widget CaptainSearch(LatLng startPosition,LatLng endPosition, String? wynkid,String? carImage,String? totalDuration){
    return FutureBuilder(
      future: lookForCaptain(context: context,
          pickupPos: startPosition, destPos: endPosition, wynkid: wynkid!,paymentMeans: context.read<FirstData>().paymentMeans),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          if(snapshot.data['statusCode'] == 201){
            //Navigator.pop(context);
            noCaptain(context);
          }
          else if(snapshot.data['statusCode'] == 202){
            print('I am Here');
            final vBal = balanceFormatter.format(snapshot.data['wallet_balance']??0);
            final rAmount =  balanceFormatter.format(snapshot.data['ride_amount']??0);
            return Container(
             // height: 300.h,
              width:MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
              padding: EdgeInsets.only(left: 40.w,right: 40.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Oops! you do not have sufficient balance to complete this ride.',style:  TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600),),
                        SizedBox(height: 15.h,),
                        Text( 'Estimated amount: ₦ ${
                            rAmount == '0.00'?'0.00':rAmount}',style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500)),
                        SizedBox(height: 5.h,),
                        Text( 'Your current vault balance: ₦ ${
                             vBal == '0.00'?'0.00':
                            vBal} ',style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      height: 51.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue
                        ),
                        onPressed: ()async{
                          context.read<FirstData>().savePaymentMeans('cash');
                          //Navigator.pop(context);
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.transparent,
                              isDismissible: false,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                              ),
                              context: context, builder: (context){
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
                                  Text('Waiting for Captain...',style: TextStyle(fontSize: 18.sp),),
                                  SizedBox(height: 14.h,),
                                  Text('Estimated drop-off time is $totalDuration',style: TextStyle(fontSize: 12.sp,color: Color(0xff0f0f0f)),),
                                  Container(
                                      margin: EdgeInsets.only(top: 6.h),
                                      width: 209.w,height: 109.h,
                                      child: Image.asset(carImage!,))
                                ],),);
                          });


                         final res = await lookForCaptain(
                           context: context, pickupPos: startPosition, destPos: endPosition, wynkid: wynkid,paymentMeans: 'cash');
                         saveDetails(res!);
                        },
                        child: Text('Pay With Cash',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    GestureDetector(
                      onTap: (){
                        context.read<FirstData>().saveGTHome(false);
                        Navigator.of(context).pushNamed('/VaultHome');
                      },
                      child: Container(
                        margin: EdgeInsets.only(top:10.h,bottom: 20.h),
                        width: MediaQuery.of(context).size.width,
                        height: 51.h,
                        decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(color: kBlack1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text('Fund Vault',
                            style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
                        ),
                      ),)
                  ],),
              ),);
          }
          else if (snapshot.data['statusCode'] == 200){

            //print(snapshot.data);
            saveDetails(snapshot.data);
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
                      child: Image.asset(carImage!,))
                ],),);}
          else{
            return Container(
              width:MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
              padding: EdgeInsets.only(left: 40.w,right: 40.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Flexible(child: SizedBox(height: 500,)),
                  Text('Please contact support team.\nThank you',style:  TextStyle(fontSize: 25.sp,fontWeight: FontWeight.w600),),
                  Flexible(child: SizedBox(height: 200,)),
                ],),);
          }
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
                  child: Image.asset(carImage!,))
            ],),);
      },
    );
  }

  void noCaptain(BuildContext context,)async{
     await Future.delayed(
         Duration.zero,()=>showDialog(
         barrierDismissible: false,
         context: context, builder: (context){
      return AlertDialog(
        contentPadding: EdgeInsets.all(20.w),
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 170.w,
              child: Text('Sorry, we are unable to locate a Captain!',
                style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
            ),
            SizedBox(height: 15.h,),
            SizedBox(
              width: 170.w,
              child: Text('Do you wish to search again?',
                style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
            ),
            GestureDetector(
              onTap:(){
                Navigator.pop(context);
                Navigator.pop(context);
                // DriverSearch(
                //     totalDuration: widget.totalDuration,
                //     carImage: widget.carImage,
                //     endPosition: widget.endPosition,
                //     startPosition: widget.startPosition,
                //     wynkid: widget.wynkid);
               // CaptainSearch(widget.startPosition, widget.endPosition, widget.wynkid, widget.carImage, widget.totalDuration);
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.transparent,
                    isDismissible: false,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    context: context, builder: (context){
                      return DriverSearch(
                      totalDuration: widget.totalDuration,
                      carImage: widget.carImage,
                      endPosition: widget.endPosition,
                      startPosition: widget.startPosition,
                      wynkid: widget.wynkid);
                });

              } ,
              child: Container(
                width: MediaQuery.of(context).size.width-50,
                margin: EdgeInsets.only(top:15.h),
                height: 51.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.black)
                ),
                child: Center(
                  child: Text('Yes',
                      style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
                ),
              ),),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top:10.h),
                width: MediaQuery.of(context).size.width,
                height: 51.h,
                decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text('No',
                    style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                ),
              ),)
          ],
        ),
      );
    }));
  }
}
