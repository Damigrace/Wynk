import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> pdf (
    Uint8List green,
    Uint8List red,
    Uint8List map,
    String riderName,
    String pickupDate,
    Uint8List walletPic,
    String capPlate,
    Uint8List capPic,
    String baseFair,
    String time,
    String distance,
    String convFee,
    String roadMaint,
    String total,
    String start,
    String end
    )async{
  final pdf = Document();
  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context){
        return[
        // Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text('Ride History',style: TextStyle(fontSize: 30,fontWeight: FontWeight.normal),),
        //       SizedBox(height: 50.h),
        //       Image(MemoryImage(to_fro)),
        //       SizedBox(height: 30.h),
        //       Image(MemoryImage(map)),
        //       SizedBox(height: 20.h),
        //       Text('Your ride with $riderName',style: TextStyle(fontSize: 16.sp),),
        //       SizedBox(height: 15.h,),
        //       // Text(context.read<CaptainDetails>().capPlate!,style: TextStyle(fontSize: 18.sp)),
        //       // SizedBox(height: 22.h,),
        //       Text(pickupDate,style: TextStyle(fontSize: 18.sp),),
        //       SizedBox(height: 50.h),
        //       Container(
        //         width: 393.w,
        //         height: 61.h,
        //         padding: EdgeInsets.only(left: 36.w, right: 36.w),
        //         decoration: BoxDecoration(
        //             border: Border.all(color: PdfColor.fromHex('211E8A'))
        //         ),
        //         child: Center(child: Row(children: [
        //           Image(MemoryImage(walletPic)),
        //           SizedBox(width: 18.w,),
        //           Flexible(child: SizedBox(width:260.w,child: Text('My Vault',style: TextStyle(fontSize: 18.sp),))),
        //           Text('NGN $fair',style: TextStyle(fontSize: 18.sp))
        //         ],) ,),
        //       ),
        //
        //     ])
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wynk Ride Invoice',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                    SizedBox(height: 30.h),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Image(MemoryImage(green)),
                          SizedBox(width: 21.w,),
                          Text( start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 18.sp),)
                        ],),
                        SizedBox(height: 38.h,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Image(MemoryImage(red)),
                          SizedBox(width: 21.w,),
                          Text( end,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 18.sp),)
                        ],),
                      ],),
                    SizedBox(height: 10.h),
                    Container(
                      width: 400.w,
                        height: 400.h,
                        child: Image(MemoryImage(map)) ),
                    SizedBox(height: 40.h),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Your ride with $riderName',style: TextStyle(fontSize: 22),),
                      SizedBox(width: 15.w),
                      SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: Image(MemoryImage(capPic)),
                      )
                    ]),
                    SizedBox(height: 15.h,),
                    Text(capPlate,style: TextStyle(fontSize: 22.sp)),
                    SizedBox(height: 22.h,),
                    Text('${DateFormat.MMMMEEEEd().format(DateTime.now())}',style: TextStyle(fontSize: 22),)
                  ],),

              ],
            ),
            SizedBox(height: 40.h),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Fare',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Text('Amount',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                ]),
            SizedBox(height: 40.h,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Base Fare',style: TextStyle(fontSize: 22),),
                  Text('NGN $baseFair',style: TextStyle(fontSize: 22),),
                ]),
            SizedBox(height: 40.h,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Time',style: TextStyle(fontSize: 22.sp),),
                  Text('NGN $time',style: TextStyle(fontSize: 22.sp),),
                ]),
            SizedBox(height: 40.h,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Distance',style: TextStyle(fontSize: 22.sp),),
                  Text('NGN $distance',style: TextStyle(fontSize: 22.sp),),
                ]),
            SizedBox(height: 40.h,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Convenience Fee',style: TextStyle(fontSize: 22.sp),),
                  Text('NGN $convFee',style: TextStyle(fontSize: 22.sp),),
                ]),
            SizedBox(height: 45.h,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Road Maintenance',style: TextStyle(fontSize: 22.sp),),
                  Text('NGN $roadMaint',style: TextStyle(fontSize: 22.sp),),
                ]),
            SizedBox(height: 40.h,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Total',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),),
                  Text('NGN $total',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),),
                ]),
            SizedBox(height: 60.h,),
            Center(child:
            Row(children: [
              Image(MemoryImage(walletPic)),
              SizedBox(width: 18.w,),
              Flexible(child: SizedBox(width:260.w,child: Text('My Vault',style: TextStyle(fontSize: 22.sp),))),
              Text('NGN $total',style: TextStyle(fontSize: 22.sp))
            ],) ,),

            SizedBox(height: 35.h,),
            Text('Thank you for riding with wynk, You are highly appreciated.',style: TextStyle(fontSize: 28.sp))
          ],
        )
        ];


      }
  ));
  return pdf.save();
}