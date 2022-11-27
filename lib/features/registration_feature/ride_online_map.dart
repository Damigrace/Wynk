import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import '../landing_pages/home_main14.dart';
import '../ride/captain_trip_summary.dart';

class GMapWebview extends StatefulWidget {

  LatLng destination;
   GMapWebview({super.key,required  this.destination});

  @override
  State<GMapWebview> createState() => _GMapWebviewState();
}

class _GMapWebviewState extends State<GMapWebview> {
  double? devWidth;
  double? devHeigth;
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  Future tripSummary(BuildContext context){
    context.read<FirstData>().saveActiveRide(false);
    return showModalBottomSheet(
        enableDrag: false,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context, builder: (context){
      return  CaptainTripSummary();
    });
  }
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // TODO: implement initState
    context.read<FirstData>().saveActiveRide(true);
    super.initState();
  }
  WebViewController? webViewCont;
  int loadingPercentage = 0;
  Offset? butPos = Offset(0,200);
  Timer? timer;
  bool notified1 = false;
  bool notified2 = false;
  payAndEndRide()async{
    print('checking if ride started');
    dynamic val = await rideStatus(rideCode: context.read<CaptainDetails>().rideCode!);

    switch(val['status_code']){

      case '9':
        {
          if(notified1 == false){
            timer?.cancel();
            notified1 = true;
            Navigator.pushReplacementNamed(context,'/RidePaymentGateway');
          }
        }

        break;
      case '1':
        {
          if(notified2 == false){
            timer?.cancel();
            notified2= true;
            Navigator.pushReplacementNamed(context,'/PatronTripEnded');
          }
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    devWidth=MediaQuery.of(context).size.width;
    devHeigth=MediaQuery.of(context).size.height;


    return Scaffold(

      body: WillPopScope(
        onWillPop: ()async{
          await showDialog(context: context, builder: (context){
            return AlertDialog(
              contentPadding: EdgeInsets.all(30.w),
              shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 170.w,
                    child: Text('Are you sure you want to leave this page?',
                      style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeMain14()));
                    } ,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top:30.h),
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
                    onTap: (){Navigator.pop(context);},
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
            );});
          return false;},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                   WebView(
                     onPageStarted: (url) {
                       setState(() {
                         loadingPercentage = 0;
                       });
                     },
                     onProgress: (progress) {
                       setState(() {
                         loadingPercentage = progress;
                       });
                     },
                     onPageFinished: (url) {

                       setState(() {
                         loadingPercentage = 100;
                       });
                     },
                    onWebViewCreated:(webViewController){
                       webViewCont = webViewController;
                      context.read<FirstData>().userType! == '3'?timer = Timer.periodic(Duration(seconds: 20), (_) async {
                        payAndEndRide();
                      }):{};
                    } ,
                     javascriptMode: JavascriptMode.unrestricted,
                     initialUrl: 'https://www.google.com/maps/dir/?api=1&destination=${widget.destination.latitude},${widget.destination.longitude}&travelmode=driving',
                  ),
                  if (loadingPercentage < 100)
                    LinearProgressIndicator(
                      value: loadingPercentage / 100.0,
                    ),

                  Positioned(
                    left: butPos!.dx,
                    top: butPos!.dy,
                    child: Draggable(
                      onDragEnd: (data){
                        setState(() {
                          butPos = data.offset;
                        });
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: kBlue),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeMain14()));
                        },child: Text('Return to Wynk'),),
                      childWhenDragging:Container(),
                      feedback:ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kBlue),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeMain14()));
                      },child: Text('Return to Wynk'),), ),
                  ),
                  Positioned(
                      top: 70.h,
                      right: 0,
                      child: GestureDetector(
                        onTap:(){
                          webViewCont!.reload();} ,
                        child: CircleAvatar(
                            backgroundColor: kBlue,
                            child: Icon(Icons.refresh)),
                      )),
                  //FloatingActionButton(onPressed: (){},child: CircleAvatar(backgroundColor: kYellow,),)
                ],
              ),
            ),
            if(context.read<FirstData>().userType! == '2')Container(
              width:devWidth ,
              decoration: const BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              child: Container(
                decoration: const BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                width: devWidth!,
                height: 80.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                        Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                        Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                      ],
                    ),
                    GestureDetector(
                        onTap: ()async{
                          spinner(context);
                          print((context.read<RideDetails>().paymentMode));
                          if(context.read<RideDetails>().paymentMode == 'cash'){

                            final pos = await determinePosition(context);
                            final res = await updateRideInfo(
                                wynkid: context.read<FirstData>().uniqueId!,
                                code: context.read<RideDetails>().rideCode!,
                                currentPos: LatLng(pos.latitude, pos.longitude),
                                rideStat: 9);
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context, builder: (context){
                              return AlertDialog(
                                title: Text('Please Confirm Ride Payment: ₦${balanceFormatter.format(double.parse(res!['total'].toString()))}'),

                                content: GestureDetector(
                                  onTap: ()async{
                                    // Navigator.pop(context);
                                    spinner(context);

                                    await patronHasPaid(context.read<RideDetails>().rideCode!);
                                    print('1');

                                    print('2');
                                    showToast(res['errorMessage'].toString());
                                    context.read<RideDetails>().saveFair(res['total'].toString());
                                    print('3');
                                    Navigator.pop(context);
                                    print('4');
                                    Navigator.pop(context);
                                    tripSummary(context);
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
                                      child: Text('Patron has paid me.',
                                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                    ),
                                  ),),
                              );
                            });
                          }
                          else if(context.read<RideDetails>().paymentMode == 'wallet'){
                            print('Ending ride');
                            refresh(context);
                            final pos = await determinePosition(context);
                            final res = await updateRideInfo(
                                wynkid: context.read<FirstData>().uniqueId!,
                                code: context.read<RideDetails>().rideCode!,
                                currentPos: LatLng(pos.latitude, pos.longitude),
                                rideStat: 9);
                            showToast(res!['errorMessage'].toString());
                            context.read<RideDetails>().saveFair(res['total'].toString());
                            Navigator.pop(context);
                            Navigator.pop(context);
                            tripSummary(context);
                          }
                        },
                        child: Text('END RIDE',style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.w500),)),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                        Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                        Icon(Icons.keyboard_arrow_right,color:Colors.white ,),
                      ],
                    ),
                  ],),
              ),)

          ],
        ),
      ),
    );
  }
}